class OpenjdkAT18 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk18u/archive/jdk-18.0.2.1-ga.tar.gz"
  sha256 "06fad73665af281e36e1cc5fb0c8ed5e88e1e821989f1421539cb012065d7722"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }
  revision 1
  
  livecheck do
    url :stable
    regex(/^jdk[._-]v?(18(?:\.\d+)*)-ga$/i)
  end
  
  bottle do
    sha256 cellar: :any, arm64_monterey: "7ca1b13127320d3a3a22f8dc65e45adcd3baedbf5e26053d516aa8847d933e12"
    sha256 cellar: :any, arm64_big_sur:  "11b3166551f1debc4e0f9e4dc63f215f513bd1c614489b9bf271bca932a4c382"
    sha256 cellar: :any, monterey:       "dbc4bb81348900c10666da4811164e4d93dc43d40d5eddcb7f43d787ca197aa6"
    sha256 cellar: :any, big_sur:        "dafb2ce75856079eff3cebcfb0ad5b015450be6f9b10db9f41dfbe3296bb189e"
    sha256 cellar: :any, catalina:       "9be65133fc3f7c2c0cda68923f497b184a73530350385d539455f6f39075565a"
    sha256               x86_64_linux:   "c4a48d0f6de1bb66912cf8b5a7e239058b1bee1e9d7391b09fba373f6f12a876"
  end
  
  keg_only :shadowed_by_macos
  
  depends_on "autoconf" => :build
  depends_on xcode: :build
  depends_on macos: :catalina
  
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "gcc"
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
        url "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_macos-x64_bin.tar.gz"
        sha256 "b85c4aaf7b141825ad3a0ea34b965e45c15d5963677e9b27235aa05f65c6df06"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz"
      sha256 "0022753d0cceecacdd3a795dd4cea2bd7ffdf9dc06e22ffd1be98411742fbb44"
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
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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
  