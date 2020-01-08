class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk13u/archive/jdk-13.0.1+9.tar.bz2"
  version "13.0.1+9"
  sha256 "97328e767bc5f47b097ec0e9d88a6a650e60c448dbaba2e835284a2bf5594eb5"

  bottle do
    cellar :any
    sha256 "cac85fcc79d435eff83fdb616cebe07ff10d3cbdd525fc61f9e5297072f346fb" => :catalina
    sha256 "f34c615559bfb80d00c8cc706d2d212e4b61217acf5dd7225946c6708d84a8ea" => :mojave
    sha256 "7b62e237d3b90fbce0b136e0ddc54224ded9cac74021fa7a7de3a4b39729b833" => :high_sierra
  end

  keg_only :provided_by_macos

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
