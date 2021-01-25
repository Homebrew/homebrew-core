class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk11u/archive/jdk-11.0.9-ga.tar.bz2"
  sha256 "0f35778a120da24dff1f752d128029d87448777a6ab9401c7cf5bc875f127d80"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "610ed0bd964812cdce0f6e1a4b8c06fd867861c72be7ebff9f674362ba48b7b9" => :big_sur
    sha256 "0257d7e29927678e60372f6d34153f9efb9e28d0d9eac7d80cddac131c6129a9" => :arm64_big_sur
    sha256 "c640eade77c3ad69fef4d66872bbccc2e8782fcd5beee84ecb6c5b7dbb28081b" => :catalina
    sha256 "facf3c10d2f0183c5f55c2e7aad5bc9ad28da3979712a7fee342bb00b5dbdd5a" => :mojave
    sha256 "4e92d71376b9e07198245e434ba86c8caa95521f6dcec8454c726cec5a16c0d1" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on xcode: :build if Hardware::CPU.arm?

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
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
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/906561d5/openjdk%4011/aarch64.diff"
      sha256 "67fbb8622df80e0ee86d6511fb07981f9c0288b9e75c4625b93add394828d658"
    end
  else
    # Fix build on Xcode 12
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2087f9d0/openjdk%4011/xcode12.diff"
      sha256 "d995c4bd49fc41ff47c4dab6f83b79b4e639c423040b7340ea13db743dfced70"
    end
  end

  def install
    framework_path = File.expand_path(
      "../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
      MacOS::Xcode.prefix,
    )

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

    args = %W[
      --without-version-pre
      --without-version-opt
      --with-version-build=#{build}
      --with-toolchain-path=/usr/bin
      --with-sysroot=#{MacOS.sdk_path}
      --with-boot-jdk=#{boot_jdk}
      --with-boot-jdk-jvmargs=#{java_options}
      --with-debug-level=release
      --with-native-debug-symbols=none
      --enable-dtrace=auto
      --with-jvm-variants=server
    ]

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

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = Dir["build/*/images/jdk-bundle/*"].first
    libexec.install jdk => "openjdk.jdk"
    bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]

    if Hardware::CPU.arm?
      dest = libexec/"openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework"
      # Copy JavaNativeFoundation.framework from Xcode
      # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
      cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

      # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
      system "codesign", "-f", "-s", "-", "#{dest}/Versions/A/JavaNativeFoundation"
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
