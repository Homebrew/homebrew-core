class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.3.0/jruby-dist-10.0.3.0-src.zip"
  sha256 "9209a9f0ed7d585e63e408e229cb629a3a18f04428373b8e8d9ed74c1e51abc2"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "46f065b8ac8e48e9226822e83c9fca0813e34ed04bc50139e8162e54782870b5"
    sha256 cellar: :any,                 arm64_sequoia: "b2621d483a2e365c44867ebda7e0ddfa78f590544fd51bb13e14b0c7f8084677"
    sha256 cellar: :any,                 arm64_sonoma:  "184d5f384bf3fd2fa14f2c58fe2f6ab4e37fdf0ba2fc6f251ee59a12b07e0d43"
    sha256 cellar: :any,                 sonoma:        "9fc51da0a640b5794ac1ccc6108dc4f0bccd93c56cd77efdeb0b870db715ccbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40af39ab7240ac8f92b961aadb31937fdadc4136764ec2acc5bacb1cf7b7bce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe0cbe6b54d86edcd954e610cf8d7f90b84226d0c55b6cd54a78e10a7d802ea"
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
