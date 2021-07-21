class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.12-ga.tar.gz"
  sha256 "8c1022b6d59d3e68d6f2a431cb9a58fca550382844625649fa49623feef45996"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "8990371b4279802b949bcff3a2064ea0a51e7a64da7449267a1c4021e2d7d6d8"
    sha256 cellar: :any,                 big_sur:       "d7e71d43ec9af2cfabd00ecc341b14349c5fb3efc02a7fcd79167471334ecb3c"
    sha256 cellar: :any,                 catalina:      "888f3f7fcd7f1cb515d39981526fb4c2b89a49ec3111b80a19ff69901648773d"
    sha256 cellar: :any,                 mojave:        "92c2f6dac0f4fa18415154a71ad4bfb09897b41d25ca063529f7a2b8e270fb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e918b207536c10a8f9e68c76c05b59c5c9f497030927a66d94c8066d79284d27"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on xcode: :build if Hardware::CPU.arm?

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "unzip"
    depends_on "zip"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"

    ignore_missing_libraries "libjvm.so"
  end

  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
        sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
      else
        url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
        sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  if Hardware::CPU.arm?
    # Patch for Apple Silicon support
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6e757d7b/openjdk%4011/aarch64.diff"
      sha256 "4425b53eac3cc1a3531972f8b4982ba8dc87d6bc763cfcd19b6cab1cbaa9e6ca"
    end
  end

  patch do
    # Fix for https://bugs.openjdk.java.net/browse/JDK-8266248 on Big Sur
    url "https://github.com/openjdk/jdk11u-dev/commit/e44258cd04fb8d1ea727d322a0e661e44306ec57.patch?full_index=1"
    sha256 "64ac56423da1d09013e4b14246fca60cb0551bda3fc2abcc23213e11f4ad709d"
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = boot_jdk_dir/"Contents/Home"
    on_linux { boot_jdk = boot_jdk_dir }
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

    args = %W[
      --without-version-pre
      --without-version-opt
      --with-version-build=#{build}
      --with-toolchain-path=/usr/bin
      --with-boot-jdk=#{boot_jdk}
      --with-boot-jdk-jvmargs=#{java_options}
      --with-debug-level=release
      --with-native-debug-symbols=none
      --enable-dtrace=auto
      --with-jvm-variants=server
    ]

    framework_path = nil
    on_macos do
      framework_path = File.expand_path(
        "../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
        MacOS::Xcode.prefix,
      )

      args << "--with-sysroot=#{MacOS.sdk_path}"

      if Hardware::CPU.arm?
        args += %W[
          --disable-warnings-as-errors
          --openjdk-target=aarch64-apple-darwin
          --with-build-jdk=#{boot_jdk}
          --with-extra-cflags=-arch\ arm64
          --with-extra-ldflags=-arch\ arm64\ -F#{framework_path}\ -headerpad_max_install_names
          --with-extra-cxxflags=-arch\ arm64
        ]
      else
        args << "--with-extra-ldflags=-headerpad_max_install_names"
      end
    end

    on_linux do
      args << "--with-x=#{HOMEBREW_PREFIX}"
      args << "--with-cups=#{HOMEBREW_PREFIX}"
      args << "--with-fontconfig=#{HOMEBREW_PREFIX}"
    end

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    on_macos do
      jdk = Dir["build/*/images/jdk-bundle/*"].first
      libexec.install jdk => "openjdk.jdk"
      bin.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/bin/*"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/*.h"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/darwin/*.h"]
      man1.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/man/man1/*"]

      if Hardware::CPU.arm?
        dest = libexec/"openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework"
        # Copy JavaNativeFoundation.framework from Xcode
        # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
        cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

        # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
        system "codesign", "-f", "-s", "-", dest/"Versions/A/JavaNativeFoundation"
      end
    end

    on_linux do
      libexec.install Dir["build/linux-x86_64-normal-server-release/images/jdk/*"]
      bin.install_symlink Dir[libexec/"bin/*"]
      include.install_symlink Dir[libexec/"include/*.h"]
      include.install_symlink Dir[libexec/"include/linux/*.h"]
      man1.install_symlink Dir[libexec/"man/man1/*"]
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
