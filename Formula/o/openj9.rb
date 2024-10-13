class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9.git",
      tag:      "openj9-0.45.0",
      revision: "0863e24b1d3f1637a418c59435c514116444106c"
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
    sha256 cellar: :any, arm64_sequoia:  "6b2ff068feb251240a81896db502226cde740b0f649c7270a46bfc0f02efca68"
    sha256 cellar: :any, arm64_sonoma:   "f3711d4ad441e50305a78958ef36d75fd0fb8077d7edc17dff6019e24e712c05"
    sha256 cellar: :any, arm64_ventura:  "b6264f5110df71fe05f0ccf3891b1115075554d4208a8bde477abc4bd02c1e5b"
    sha256 cellar: :any, arm64_monterey: "8f1ba8afb4421165fa50c03192a445515b92edf077fc03337775f0dddc456565"
    sha256 cellar: :any, sonoma:         "bed60cb68b71351c4780378f1e98e70b146c49d237aabc82613c4a735403e680"
    sha256 cellar: :any, ventura:        "8d51623586575d0b78c1c89507fbf0c8a24b4a5f6d3c407c62e27b1a42cc418d"
    sha256 cellar: :any, monterey:       "e00e0214d619e27f1a4355dc24a60bd09a66b1ed783b05e19a7f0ad9b16e8c8d"
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
  # We use JDK 22 to bootstrap.
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_aarch64_mac_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "623cc15daa3b4c7f21d47f225c94a163e2261074cc3c11f30d2938fc249b9355"
      end
      on_intel do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_x64_mac_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "f0e459df70b5a3c8fc0abc099d5c06a596da40b95f8226d76474516a646a3861"
      end
    end
    on_linux do
      url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_x64_linux_22.0.1_8_openj9-0.45.0.tar.gz"
      sha256 "6e54d984bc0c058ffb7a604810dfffba210d79e12855e5c61e9295fedeff32db"
    end
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr.git",
        tag:      "openj9-0.45.0",
        revision: "254af5a0452934f62e3253c5565b183c682d3495"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk22.git",
        tag:      "openj9-0.45.0",
        revision: "980fc841b6b683f31a8fde962b63dbd9ca97bd6a"
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
      rm_r(Dir.glob(jdk/"**/*.dSYM"))
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
