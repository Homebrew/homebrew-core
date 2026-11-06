class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.1.3.0/jruby-dist-10.1.3.0-src.zip"
  sha256 "8b33682fd33f0338e9435ed9941d60d5b1ad5b28bc3ee688c1a288d039252dc6"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a13eac35582c548fb83bb933e35dafdd98120a08fad13904cbd802b975e8be60"
    sha256 cellar: :any, arm64_tahoe:       "dc76d17f8c561f9f5e01a0dd0aab19ef7526ac528da092c2fe64866a08904452"
    sha256 cellar: :any, arm64_sequoia:     "afbcce81a9121c10e95c10b1bd64848bd272bba81f3265d5bc217a38e4b66077"
    sha256 cellar: :any, arm64_linux:       "2cdb08e666b5986e4cd08a48414152589e8107900ce2ae1bd44dcf03ae551e87"
    sha256 cellar: :any, x86_64_linux:      "dcadbcd10e8091e88ba74f639cbb62a35c0a67a815baf664d9771e6df8ab0ebb"
  end

  depends_on "ant" => :build # for jffi
  depends_on "maven" => :build
  depends_on "pkgconf" => :build # for jffi
  depends_on "ruby" => :build # only used to detect conflicts

  depends_on "libfixposix" => :no_linkage
  depends_on "openjdk"

  uses_from_macos "libffi" # for jffi

  resource "jffi" do
    url "https://github.com/jnr/jffi/archive/refs/tags/jffi-1.4.7.tar.gz"
    sha256 "be9b8369acac1baa1b08872ecfd64c7d8fe00206ad65bca830881edbb3293e52"

    livecheck do
      url "https://raw.githubusercontent.com/jruby/jruby/refs/tags/#{LATEST_VERSION}/pom.xml"
      strategy :xml do |xml|
        xml.get_elements("//properties/jffi.version").map(&:text)
      end
    end
  end

  def install
    jffi_version = Version.new(File.read("pom.xml")[/<jffi\.version>([\d.]+)</i, 1])
    resource("jffi").stage do |r|
      odie "Need jffi version #{jffi_version}!" if r.version != jffi_version

      # Remove pre-built binaries and bundled libffi
      rm(Dir["archive/*"])
      rm_r("jni/libffi")
      ENV["LIBFFI_LIBS"] = if OS.mac?
        MacOS.sdk_for_formula(self).path/"usr/lib/libffi.tbd"
      else
        formula_opt_lib("libffi")/shared_library("libffi")
      end

      # Avoid building universal binaries. Cannot use change_make_var! due to indentation
      inreplace "jni/GNUmakefile", "ARCHES = x86_64 arm64", "ARCHES = #{Hardware::CPU.arch}"

      # Compile the sun.misc.Unsafe-using class with -source/-target (like jffi 1.3)
      inreplace "pom.xml" do |s|
        s.gsub!(%r{<configuration>(\s+)<jdkToolchain>\s+<version>8</version>\s+</jdkToolchain>},
                "<configuration combine.self=\"override\">\\1<source>8</source>\\1<target>8</target>")
      end

      system "ant", "-Duse.system.libffi=1", "jar"
      system "ant", "-Duse.system.libffi=1", "archive-platform-jar"
      # jnr-parent sets `maven.compiler.release` to 8, which hides `sun.misc` from the class above.
      # Javadoc is not needed and fails without that release value.
      system "mvn", "package", "-Dmaven.compiler.release=", "-Dmaven.javadoc.skip=true"

      # Install JARs into local repository to be used by Maven when building JRuby
      system "mvn", "install:install-file", "-Dfile=target/jffi-#{r.version}.jar"
      system "mvn", "install:install-file", "-Dfile=target/jffi-#{r.version}-native.jar",
                                            "-DgroupId=com.github.jnr",
                                            "-DartifactId=jffi",
                                            "-Dpackaging=jar",
                                            "-Dversion=#{r.version}",
                                            "-Dclassifier=native"
    end

    system "mvn", "-Pdist"
    libexec.mkpath
    tarball = "maven/jruby-dist/target/jruby-dist-#{version}-bin.tar.gz"
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"

    # Make sure locally built copy was used by checking there is a single library
    jni_libs = libexec.glob("lib/jni/**/*jffi*").select(&:file?)
    odie "Expected single jffi library but found:\n  #{jni_libs.join("\n  ")}." unless jni_libs.one?

    # Remove Windows files and ffi-binary-libfixposix gem (pre-built libfixposix)
    rm libexec.glob("bin/*.{bat,dll,exe}")
    rm libexec/"lib/ruby/stdlib/libfixposix/binary.rb"
    rm_r libexec/"lib/ruby/stdlib/libfixposix/binary"

    # Expose commands on PATH but prefix a 'j' on any that conflict with Ruby
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    (bin.children(false) & Formula["ruby"].bin.children(false)).each do |cmd|
      if (bin/"j#{cmd}").exist?
        rm(bin/cmd)
      else
        bin.install bin/cmd => "j#{cmd}"
      end
    end
  end

  test do
    ENV["JRUBY_JSA"] = testpath/"jruby.jsa"

    assert_equal "hello\n", shell_output("#{bin}/jruby -e 'puts :hello'")

    ENV["GEM_HOME"] = testpath
    system bin/"jgem", "install", "json"
  end
end
