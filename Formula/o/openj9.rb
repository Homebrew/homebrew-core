class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9.git",
      tag:      "openj9-0.42.0",
      revision: "874af12ee223ef0ceca48c2b52ec9931e4cacf45"
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
    sha256 cellar: :any, arm64_monterey: "aed97a9ad250d831d56e98fe4cc42a04accc9573105d35b720786e97615f53f9"
    sha256 cellar: :any, arm64_big_sur:  "6c138a8cb5d443c3f3fedf74a820cfe7dacc8c3f1dd8fdd633cd3bbf93a829a1"
    sha256 cellar: :any, sonoma:         "f9abe0dc7f76e36e776d7302990c61b857407f12004d7b6afe4d75f9a3275978"
    sha256 cellar: :any, ventura:        "d03b9d60f11cd19ccb14438849675d1314c2306a7091b6d6ca16a2d1c9d6bd72"
    sha256 cellar: :any, monterey:       "506c3ce6be273f87b953d5b7820aa567e29693e39243ed120f9d06c0031c8cda"
    sha256 cellar: :any, big_sur:        "bd6cfe66db144260f4d961b4a462414de966f5ab585c05b2850ab9c1d99db65b"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "m4" => :build
  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with openjdk"

    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "numactl"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # From https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # We use JDK 21 to bootstrap.
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://github.com/AdoptOpenJDK/semeru21-binaries/releases/download/jdk-21.0.1%2B12_openj9-0.42.0/ibm-semeru-open-jdk_aarch64_mac_21.0.1_12_openj9-0.42.0.tar.gz"
        sha256 "def95faa925d691d1d2ac1a3b5971b534b3f5b7af532424713bb66575bc49ea0"
      end
      on_intel do
        url "https://github.com/AdoptOpenJDK/semeru21-binaries/releases/download/jdk-21.0.1%2B12_openj9-0.42.0/ibm-semeru-open-jdk_x64_mac_21.0.1_12_openj9-0.42.0.tar.gz"
        sha256 "6ea3a8c1ddb22dea74530e145b3c1b96e94aa044a584bd9bfa4f5fff2cc21f73"
      end
    end
    on_linux do
      url "https://github.com/AdoptOpenJDK/semeru21-binaries/releases/download/jdk-21.0.1%2B12_openj9-0.42.0/ibm-semeru-open-jdk_x64_linux_21.0.1_12_openj9-0.42.0.tar.gz"
      sha256 "ad575bc4b1fa9e9fa56661444b6153abfa147ec155845afa054472fa6357f026"
    end
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr.git",
        tag:      "openj9-0.42.0",
        revision: "11700e64f9ba0de02e42481e4c1fb63aaa347b1b"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk21.git",
        tag:      "openj9-0.42.0",
        revision: "cb91cd755e3a0c7832e4f84eae258a8d19de4ec9"
  end

  def install
    openj9_files = buildpath.children
    (buildpath/"openj9").install openj9_files
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

    config_args = %W[
      --disable-warnings-as-errors-omr
      --disable-warnings-as-errors-openj9
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none

      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre

      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system

      --enable-ddr=no
      --enable-full-docs=no
    ]
    config_args += if OS.mac?
      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      # Override hardcoded /usr/include directory when checking for numa headers
      inreplace "closed/autoconf/custom-hook.m4", "/usr/include/numa", Formula["numactl"].opt_include/"numa"

      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{Formula["cups"].opt_prefix}
        --with-fontconfig=#{Formula["fontconfig"].opt_prefix}
      ]
    end
    # Ref: https://github.com/eclipse-openj9/openj9/issues/13767
    # TODO: Remove once compressed refs mode is supported on Apple Silicon
    config_args << "--with-noncompressedrefs" if OS.mac? && Hardware::CPU.arm?

    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "all", "-j"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openj9.jdk"
      jdk /= "openj9.jdk/Contents/Home"
      rm jdk/"lib/src.zip"
      rm_rf Dir.glob(jdk/"**/*.dSYM")
    else
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
      EOS
    end
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
