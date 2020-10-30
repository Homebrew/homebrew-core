class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk11u/archive/jdk-11.0.9-ga.tar.bz2"
  sha256 "0f35778a120da24dff1f752d128029d87448777a6ab9401c7cf5bc875f127d80"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "c640eade77c3ad69fef4d66872bbccc2e8782fcd5beee84ecb6c5b7dbb28081b" => :catalina
    sha256 "facf3c10d2f0183c5f55c2e7aad5bc9ad28da3979712a7fee342bb00b5dbdd5a" => :mojave
    sha256 "4e92d71376b9e07198245e434ba86c8caa95521f6dcec8454c726cec5a16c0d1" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  resource "boot-jdk" do
    on_macos do
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
      sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  # Fix build on Xcode 12
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2087f9d035e568655d3f4240827e9cb7f31370da/openjdk%4011/xcode12.diff"
    sha256 "d995c4bd49fc41ff47c4dab6f83b79b4e639c423040b7340ea13db743dfced70"
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Inspecting .hg_archival.txt to find a build number
    # The file looks like this:
    #
    # repo: fd16c54261b32be1aaedd863b7e856801b7f8543
    # node: 4397fa4529b2794ddcdf3445c0611fe383243fb4
    # branch: default
    # tag: jdk-11.0.9+11
    # tag: jdk-11.0.9-ga
    #
    build = File.read(".hg_archival.txt")
                .scan(/^tag: jdk-#{version}\+(.+)$/)
                .map(&:first)
                .map(&:to_i)
                .max
    raise "cannot find build number in .hg_archival.txt" if build.nil?

    chmod 0755, "configure"
    system "./configure", "--without-version-pre",
                          "--without-version-opt",
                          "--with-version-build=#{build}",
                          "--with-toolchain-path=/usr/bin",
                          "--with-sysroot=#{MacOS.sdk_path}",
                          "--with-extra-ldflags=-headerpad_max_install_names",
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-debug-level=release",
                          "--with-native-debug-symbols=none",
                          "--enable-dtrace=auto",
                          "--with-jvm-variants=server"

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openjdk.jdk"
    bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
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
