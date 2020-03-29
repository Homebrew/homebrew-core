class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk13u/archive/jdk-13.0.2+8.tar.bz2"
  version "13.0.2+8"
  sha256 "01059532335fefc5e0e7a23cc79eeb1dc6fea477606981b89f259aa0e0f9abc1"
  revision 2

  bottle do
    cellar :any
    sha256 "65adca036393f528e3830cab8b0aafec94be870de087d94cfe098fd593517307" => :catalina
    sha256 "6034ec5a0927803eae37a5e85b6c6efadb930527827b45ecc593e25a9750061c" => :mojave
    sha256 "358101f25201e4c942297223d854ef95003798fe5396ebc671efa359c27e3d22" => :high_sierra
  end

  keg_only "it shadows the macOS `java` wrapper"

  depends_on "autoconf" => :build

  resource "boot-jdk" do
    url "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_osx-x64_bin.tar.gz"
    sha256 "675a739ab89b28a8db89510f87cb2ec3206ec6662fb4b4996264c16c72cdd2a1"
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    java_options = ENV.delete("_JAVA_OPTIONS")

    short_version, _, build = version.to_s.rpartition("+")

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
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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
