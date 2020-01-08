class OpenjdkAT12 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk12u/archive/jdk-12.0.2+10.tar.bz2"
  version "12.0.2+10"
  sha256 "f7242b56e0292bc7ec5795bbaeb98552ef30d7a686cd7ca0a877fe37b399f384"

  bottle do
    cellar :any
    sha256 "3892b99f99b2074c70bbae87b6d17cb26253b4021ea9ca7e032fe7be12b9b972" => :catalina
    sha256 "846447341bfe7c51ce60db6b3e56b88934ef4266e96386c975cf7e2f50e84ba6" => :mojave
    sha256 "8967f8909149bc48637dc06da8670380224b1ca3e41c654688d82c1dfd41a77a" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build

  resource "boot-jdk" do
    url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
    sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    java_options = ENV.delete("_JAVA_OPTIONS")

    short_version, _, build = version.to_s.rpartition("+")

    # Fix compile error due to -Werror.
    # https://bugs.openjdk.java.net/browse/JDK-8223309
    # https://bugs.openjdk.java.net/browse/JDK-8233448
    inreplace "make/autoconf/flags-cflags.m4",
      'DISABLED_WARNINGS="unused-parameter unused"',
      'DISABLED_WARNINGS="unknown-warning-option unused-parameter unused"'
    inreplace "make/hotspot/lib/CompileGtest.gmk",
      "undef switch format-nonliteral tautological-undefined-compare,",
      "undef switch format-nonliteral tautological-undefined-compare self-assign-overloaded,"

    chmod 0755, "configure"
    system "./configure", "--without-version-pre",
                          "--without-version-opt",
                          "--with-version-build=#{build}",
                          "--with-toolchain-path=/usr/bin",
                          "--with-extra-ldflags=-headerpad_max_install_names",
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-debug-level=release",
                          "--with-native-debug-symbols=none",
                          "--enable-dtrace=auto",
                          "--with-jvm-variants=server"

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    libexec.install "build/macosx-x86_64-server-release/images/jdk-bundle/jdk-#{short_version}.jdk" => "openjdk.jdk"
    bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-12.jdk
    EOS
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
