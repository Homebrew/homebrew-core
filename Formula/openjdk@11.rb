class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.16.1-ga.tar.gz"
  sha256 "3008e50e258a5e9a488a814df2998b9823b6c2959d6a5a85221d333534d2f24c"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec9827ab4a3895ddb6739939af6dc3426fd09995a805af69daccf099ac4301ab"
    sha256 cellar: :any,                 arm64_monterey: "81eccbbd81a405f07a1ac2bb0f3ccaef70d2f586a26f6c9b5326a4deb9d30404"
    sha256 cellar: :any,                 arm64_big_sur:  "ef1efd7cb78ff5d788dabcef4ff376b214f422584d9b50ae086965ebe4c2e607"
    sha256 cellar: :any,                 ventura:        "4157114f6dd128b93d0732559787f191678d2d496476e19855a03d0f226aa50c"
    sha256 cellar: :any,                 monterey:       "938120ca00af5d30d606a37576fe11394511bfe1ac9d36817e8d4da4c662e92b"
    sha256 cellar: :any,                 big_sur:        "a0943ce186432e16eab04996b743f4a52c1d4eb365a4f0fb9d2283d6554fc810"
    sha256 cellar: :any,                 catalina:       "bdbb96550f521b4c79ffe9c8651c97b5a28fdf75061a3aff84c2ae57b2ad95dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef7857996800a12b2441c499e46b80695eb090efef5e4b7e3f9c44ae89620d7"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "unzip"
    depends_on "zip"

    # FIXME: This should not be needed because of the `-rpath` flag
    #        we set in `--with-extra-ldflags`, but this configuration
    #        does not appear to have made it to the linker.
    ignore_missing_libraries "libjvm.so"
  end

  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.58.15-ca-jdk11.0.16-macosx_aarch64.tar.gz"
        sha256 "cb71a8ad38755f881a692098ca02378183a7a9c5093d7e6ad98ca5e7bc74b937"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
        sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  def install
    boot_jdk = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac? && !Hardware::CPU.arm?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-hotspot-gtest
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-jvm-features=shenandoahgc
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --without-version-opt
      --without-version-pre
    ]

    ldflags = ["-Wl,-rpath,#{loader_path}/server"]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images", "CONF=release"

    cd "build/release/images" do
      jdk = libexec
      if OS.mac?
        libexec.install Dir["jdk-bundle/*"].first => "openjdk.jdk"
        jdk /= "openjdk.jdk/Contents/Home"
      else
        libexec.install Dir["jdk/*"]
      end

      bin.install_symlink Dir[jdk/"bin/*"]
      include.install_symlink Dir[jdk/"include/*.h"]
      include.install_symlink Dir[jdk/"include/*/*.h"]
      man1.install_symlink Dir[jdk/"man/man1/*"]
    end
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
