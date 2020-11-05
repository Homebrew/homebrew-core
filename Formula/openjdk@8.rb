class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u272-ga.tar.bz2"
  version "1.8.0+272"
  sha256 "a80476dfe32c12882fe2d87bdb0dd37fc4a0dae8dd95f0c22c7c2445fc08ff7e"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "a10deef9727306433d7636522a6a145bfeb84b8be1bb64954b14807f5bf53df0" => :catalina
    sha256 "1dd09cfcedd6e4fef1246986fa2f694aafb44452059618dae9f8203b1fe65946" => :mojave
    sha256 "d75758be09e53521eb80402bad4f6d0c7ad6c31f176a08c7f0b1af73c2ac3abb" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"

  # Oracle doesn't serve JDK 7 downloads anymore, so use Zulu JDK 7 for bootstrapping.
  resource "boot-jdk" do
    on_macos do
      url "https://cdn.azul.com/zulu/bin/zulu7.40.0.15-ca-jdk7.0.272-macosx_x64.tar.gz"
      sha256 "d09468bda072deeadd2a5e39aeae96b57ece2ec5fdbdc75998b99b52c113706b"
    end
    on_linux do
      url "https://cdn.azul.com/zulu/bin/zulu7.40.0.15-ca-jdk7.0.272-linux_x64.tar.gz"
      sha256 "5efbf721a4335a19c8c3fbf2cf2fce8d1c6b4a766fb93e98f9303845f89d901e"
    end
  end

  # These are typically set up as a Mercurial "forest" checkout, but we download
  # the tarballs and stage them directly to avoid running upstream's unversioned
  # `get_source.sh` script.
  resource "corba" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/corba/archive/jdk8u272-ga.tar.bz2"
    sha256 "51212e37b6c6e120901e61b830f110bbd121e9c4611aec9ff4e3f404a667855f"
  end

  resource "hotspot" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/archive/jdk8u272-ga.tar.bz2"
    sha256 "a8c83dcd272dc29c538291f24d1b28b7069e048398681b6db082cdaa8f3a6b07"
  end

  resource "jaxp" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jaxp/archive/jdk8u272-ga.tar.bz2"
    sha256 "3f8b02337f4cd96e9180aa118705f48c39562f66287b46dd69554221fa196084"
  end

  resource "jaxws" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jaxws/archive/jdk8u272-ga.tar.bz2"
    sha256 "ed276f9a70bf2582183838ad8b1874c0993b4a28741c69f095669667b12cd3d4"
  end

  resource "jdk" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jdk/archive/jdk8u272-ga.tar.bz2"
    sha256 "a3deeab4ac721d1ce9d8a2fb1917ba9e2afc6041f03ad4a342e9a5441cce621d"
  end

  resource "langtools" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/langtools/archive/jdk8u272-ga.tar.bz2"
    sha256 "ed59eabe4eb3fcf9af592d1af2d052c5053da9d868542fc47a0bddcb91e69c60"
  end

  resource "nashorn" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/nashorn/archive/jdk8u272-ga.tar.bz2"
    sha256 "a5b8c478cd7695bf83210b8e97be3bfc8248c22916cec3b8b869586c3d7f0007"
  end

  # Apply this upstreamed patch to build on newer Xcode.
  # https://github.com/AdoptOpenJDK/openjdk-jdk8u/pull/10
  resource "patch" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9976a857d574de2927c580f1f61bcd647fb795fe/openjdk%408/xcode.patch"
    sha256 "f59a82f2e83c97a7496ba71c811ee0849d7df6b45e32fb3da0f0078386eebd80"
  end

  def install
    _, _, update = version.to_s.rpartition("+")
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Stage all subpackages and set the path for the bootstrap JDK 7.
    %w[boot-jdk corba hotspot jaxp jaxws jdk langtools nashorn].each { |r| resource(r).stage(buildpath/r) }
    boot_jdk = buildpath/"boot-jdk"

    # Patches must be applied as resources because they assume a
    # full Mercurial "forest" checkout.
    resource("patch").stage(buildpath)
    patch = Dir["*.patch"].first
    system "patch -g 0 -f -p1 < #{patch}"
    rm patch

    # Work around clashing -I/usr/include and -isystem headers,
    # as superenv already handles this detail for us.
    inreplace "common/autoconf/flags.m4",
      '-isysroot \"$SYSROOT\"', ""
    inreplace "common/autoconf/toolchain.m4",
      '-isysroot \"$SDKPATH\" -iframework\"$SDKPATH/System/Library/Frameworks\"', ""
    inreplace "hotspot/make/bsd/makefiles/saproc.make",
      '-isysroot "$(SDKPATH)" -iframework"$(SDKPATH)/System/Library/Frameworks"', ""

    # Fix macOS version detection. After 10.10 this was changed to a 6 digit number,
    # but this Makefile was written in the era of 4 digit numbers.
    inreplace "hotspot/make/bsd/makefiles/gcc.make" do |s|
      s.gsub! "$(subst .,,$(MACOSX_VERSION_MIN))", ENV["HOMEBREW_MACOS_VERSION_NUMERIC"]
      s.gsub! "MACOSX_VERSION_MIN=10.7.0", "MACOSX_VERSION_MIN=#{MacOS.version}"
    end

    # Fix to permit building with Xcode 12
    inreplace "common/autoconf/toolchain.m4",
      '"${XC_VERSION_PARTS[[0]]}" != "4"',
      '"${XC_VERSION_PARTS[[0]]}" != "12"'

    chmod 0755, %w[configure common/autoconf/autogen.sh]
    system "common/autoconf/autogen.sh"
    system "./configure", "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-debug-level=release",
                          "--with-jvm-variants=server",
                          "--with-milestone=fcs",
                          "--with-native-debug-symbols=none",
                          "--with-toolchain-type=clang",
                          "--with-update-version=#{update}"

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = Dir["build/*/images/j2sdk-bundle/*"].first
    libexec.install jdk => "openjdk.jdk"
    bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
    include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
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
