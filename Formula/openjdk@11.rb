class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.16.1-ga.tar.gz"
  sha256 "3008e50e258a5e9a488a814df2998b9823b6c2959d6a5a85221d333534d2f24c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b0bbc489ad3d90cdb4fe38e6bf5d99b07213c2c3b556123d976adc535669bae4"
    sha256 cellar: :any,                 arm64_big_sur:  "f0b5f931982c8bff61622b4ae30c5ee65b8986c32d8fde4a4d9a5e6d4e2e16bd"
    sha256 cellar: :any,                 monterey:       "21efec7c8512fe053c688d423d74c319469efe07871bc0c516b8c767eb07a808"
    sha256 cellar: :any,                 big_sur:        "cda46db2148b805fdb72d35f5e5568c4e18f6a72ffdb69185a6f5754ed5ceb1f"
    sha256 cellar: :any,                 catalina:       "7795a9a9e3c15157e783addc144149fc0b2fadeb343bf2dcc4c6b90b81e82d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da630be1fa3be631faca104096246af1f5da52dcda7c35afe267ef1e276df20a"
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

    args += if OS.mac?
      %W[
        --with-sysroot=#{MacOS.sdk_path}
        --enable-dtrace=auto
        --with-extra-ldflags=-headerpad_max_install_names
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
      ]
    end

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
