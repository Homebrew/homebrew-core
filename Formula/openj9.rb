class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse/openj9.git",
      tag:      "openj9-0.29.1",
      revision: "7d055dfcb71452077db01fddfc3ccd845cd461d0"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
    { "GPL-2.0-only" => { with: "OpenJDK-assembly-exception-1.0" } },
  ]

  livecheck do
    url :stable
    regex(/^openj9-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "19290d492bbc5684b9ea8a66ba478e35c6d7ee3ade64d62770b764654ea29772"
    sha256 cellar: :any, big_sur:  "75530242133eccf385b0e9f5afbce7652171ec596e8d0ba922ebfab28f87689b"
    sha256 cellar: :any, catalina: "934fb20d912d385774e529262672c3b9161ccf5b13c3db62ace7657613773b5b"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "nasm" => :build if Hardware::CPU.intel?
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64

  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  resource "boot-jdk" do
    url "https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_mac_hotspot_16.0.1_9.tar.gz"
    sha256 "3be78eb2b0bf0a6edef2a8f543958d6e249a70c71e4d7347f9edb831135a16b8"
  end

  resource "omr" do
    url "https://github.com/eclipse/openj9-omr.git",
        tag:      "openj9-0.29.1",
        revision: "e30892e2b525e89712747040b4186b9a055a93ce"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk16.git",
        branch:   "v0.27.1-release",
        revision: "a269b697f0c4ad5f8d16ff510aa7058c37c1da0b"
  end

  def install
    openj9_files = buildpath.children
    (buildpath/"openj9").install openj9_files
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    resource("boot-jdk").stage buildpath/"boot-jdk"

    config_args = %W[
      --with-boot-jdk=#{buildpath}/boot-jdk/Contents/Home
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-sysroot=#{MacOS.sdk_path}

      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system

      --enable-ddr=no
      --enable-dtrace
      --enable-full-docs=no
    ]

    ENV.delete "_JAVA_OPTIONS"
    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "all", "-j"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openj9.jdk"
    rm libexec/"openj9.jdk/Contents/Home/lib/src.zip"
    rm_rf Dir.glob(libexec/"openj9.jdk/Contents/Home/**/*.dSYM")

    bin.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openj9.jdk/Contents/Home/include/darwin/*.h"]
    share.install_symlink libexec/"openj9.jdk/Contents/Home/man"
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
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
