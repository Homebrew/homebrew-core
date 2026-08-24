class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.1.1.0/jruby-dist-10.1.1.0-src.zip"
  sha256 "825d47f43ef288b218b965406ef8a97117c9b080986b3ad9883e1850da312166"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef135ad4275bf5e0e0c2a15dfc86ef1ad8cd81430ce99b1f4bf5d8160073826f"
    sha256 cellar: :any, arm64_sequoia: "9fc40e6063f4d1657f4f05830c65ae7c3a408d895fa853712e468b20a1456933"
    sha256 cellar: :any, arm64_sonoma:  "5aee533ae387d52f08194ed37f52b1316860d6e9d4a9b133e486e0f1f28310d5"
    sha256 cellar: :any, sonoma:        "f925279918b068fbb0ac7257fc448c76126ad3a66154f8315fda98f8b880ec57"
    sha256 cellar: :any, arm64_linux:   "cae9427d6b4e1f4b065debd0ead51ca33f35b0f52b2f95dd07acec51361517db"
    sha256 cellar: :any, x86_64_linux:  "791ee764e797b26044ffe9645058435d8de83628706fadc322741f8bda0d5873"
  end

  depends_on "ant" => :build # for jffi
  depends_on "maven" => :build
  depends_on "pkgconf" => :build # for jffi
  depends_on "ruby" => :build # only used to detect conflicts

  depends_on "libfixposix" => :no_linkage
  depends_on "openjdk"

  uses_from_macos "libffi" # for jffi

  resource "jffi" do
    url "https://github.com/jnr/jffi/archive/refs/tags/1.4.0.tar.gz"
    sha256 "1cc8174ca1fb86a3400da5838705d455c0be59fd93f2d675512dcb2f727fe45f"

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
      system "mvn", "package"

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
