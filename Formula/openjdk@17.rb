class OpenjdkAT17 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk17u/archive/jdk-17.0.5-ga.tar.gz"
  sha256 "a3a72a1897b6c01a68307a80a3b987114b7722f2541debd018e362a7c0917b85"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(17(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0ad3ce7237dbc948aa314be7cebcc729c30bcd8eef08277fa464287f9211c426"
    sha256 cellar: :any, arm64_monterey: "0e2244e35a350256474b6eb6e03d11af5c0270ab7ca4e6bc710c6273cb087b24"
    sha256 cellar: :any, arm64_big_sur:  "911d64028e026092ce9f8f4b1a7d3c95bd7d631941d057afd5fec646a5e968d1"
    sha256 cellar: :any, ventura:        "5c424f6cf45913e05b1b394c2aff0281c0d4e32982a0ee33e05d16144e1a05af"
    sha256 cellar: :any, monterey:       "c1ac28437f8c07409f386e1a3d4d1738fc70b80081579efb64dd6e831a2d78fc"
    sha256 cellar: :any, big_sur:        "b9093c0c83b7964496208e4abb8805c335f2c8fc916c85148c08324c64e26a10"
    sha256 cellar: :any, catalina:       "9e21c33ba30e623252df8f74a33b8db56d61753a56f1c3c2aa9891f174152439"
    sha256               x86_64_linux:   "75bfd5b65e8718cc6f2818a78d5d279520901f6f049fcbcbe9928304220b7e60"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on xcode: :build

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

  fails_with gcc: "5"

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_macos-aarch64_bin.tar.gz"
        sha256 "602d7de72526368bb3f80d95c4427696ea639d2e0cc40455f53ff0bbb18c27c8"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_osx-x64_bin.tar.gz"
        sha256 "e65f2437585f16a01fa8e10139d0d855e8a74396a1dfb0163294ed17edd704b8"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz"
      sha256 "6c714ded7d881ca54970ec949e283f43d673a142fda1de79b646ddd619da9c0c"
    end
  end

  def install
    boot_jdk = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-warnings-as-errors
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
    system "make", "images"

    if OS.mac?
      jdk = Dir["build/*/images/jdk-bundle/*"].first
      libexec.install jdk => "openjdk.jdk"
      bin.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/bin/*"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/*.h"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/darwin/*.h"]
      man1.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/man/man1/*"]
    else
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
      bin.install_symlink Dir[libexec/"bin/*"]
      include.install_symlink Dir[libexec/"include/*.h"]
      include.install_symlink Dir[libexec/"include/linux/*.h"]
      man1.install_symlink Dir[libexec/"man/man1/*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
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
