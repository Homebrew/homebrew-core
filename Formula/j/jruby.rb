class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.4.0/jruby-dist-10.0.4.0-src.zip"
  sha256 "14970303abd383e5cbdd62fc12240fc500ca56ac67043fdab12acd12c0bc33e1"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bb65182d298172002cf8f395d0608edefa6222e827575e5849e1ad51dee865a"
    sha256 cellar: :any,                 arm64_sequoia: "c933a215eb77587117a4bfa0b7c47aa4cd12add469ddbd195c4707d6860369e8"
    sha256 cellar: :any,                 arm64_sonoma:  "15a760ae69f18d4ab4e802803bcedc4660696345e0a9cddf2ccd9db51809a5c0"
    sha256 cellar: :any,                 sonoma:        "cd35107cc3ba2df332a350399a2c1ee6c591ca3f138efd22bc1679829ef83b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0139a9da688e5abf02eeb8bad825e4d41649c8178aa6a15f960e5ec4383ec57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5d25230676021c5e8cf6d7ed6854122a9d132ec297b07974255d93ea71c083"
  end

  depends_on "ant" => :build # for jffi
  depends_on "maven" => :build
  depends_on "pkgconf" => :build # for jffi
  depends_on "ruby" => :build # only used to detect conflicts

  depends_on "libfixposix" => :no_linkage
  depends_on "openjdk"

  uses_from_macos "libffi" # for jffi

  resource "jffi" do
    url "https://github.com/jnr/jffi/archive/refs/tags/jffi-1.3.14.tar.gz"
    sha256 "dfc120bc832cd81940fb785bef2987bd3f54199fddbed0e62145718d5a3d3b95"

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
        Formula["libffi"].opt_lib/shared_library("libffi")
      end

      # Avoid building universal binaries. Cannot use change_make_var! due to indentation
      inreplace "jni/GNUmakefile", "ARCHES = x86_64 arm64", "ARCHES = #{Hardware::CPU.arch}"

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
    assert_equal "hello\n", shell_output("#{bin}/jruby -e 'puts :hello'")

    ENV["GEM_HOME"] = testpath
    system bin/"jgem", "install", "json"
  end
end
