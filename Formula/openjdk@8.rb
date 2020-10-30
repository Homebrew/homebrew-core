class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u265-ga.tar.bz2"
  version "1.8.0+265"
  sha256 "b5fd22b2f4a0a59611373e5f1ffc423d26e62ea38f1084a80a401beb6bd04d88"
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
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/corba/archive/jdk8u265-ga.tar.bz2"
    sha256 "a3adf57f7d50155bb83926afc2ca0007c6f17602660bacaff67201dd886b379f"
  end

  resource "hotspot" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/archive/jdk8u265-ga.tar.bz2"
    sha256 "b4f6ab5466fc73f6e015d5394b4204453a109dc532e8bbac069c46c109545ce6"
  end

  resource "jaxp" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jaxp/archive/jdk8u265-ga.tar.bz2"
    sha256 "d8e6a5bf406bf32f7806081907bd299098f13ade00260a737d3c141bcc2890a9"
  end

  resource "jaxws" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jaxws/archive/jdk8u265-ga.tar.bz2"
    sha256 "436a0aaecda8f2cc66ef2cbccea34a85887e5646fff60036473c08f975a68e33"
  end

  resource "jdk" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/jdk/archive/jdk8u265-ga.tar.bz2"
    sha256 "f9ca5bcda71f91d087d7483c1ae53d266a92f9691836f1cbbfaa37a9993f1f9b"
  end

  resource "langtools" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/langtools/archive/jdk8u265-ga.tar.bz2"
    sha256 "ea33875d91addd8f6dd52afe5cfa11c108f0e378df8451ed22a4e6767576c899"
  end

  resource "nashorn" do
    url "https://hg.openjdk.java.net/jdk8u/jdk8u/nashorn/archive/jdk8u265-ga.tar.bz2"
    sha256 "660148fab294a98147d346209e19b6dcf82807588d3c8c54abfc1262c95043d4"
  end

  # Apply this upstreamed patch series to build on newer Xcode.
  # https://github.com/AdoptOpenJDK/openjdk-jdk8u/pull/10
  resource "patch1" do
    url "https://github.com/AdoptOpenJDK/openjdk-jdk8u/commit/3f637d28dfeba8cf1391c9e70a89c0aac0f2150a.patch?full_index=1"
    sha256 "36bebf72b2972c9fb7766745d67234c7a379d5fcdddec760d8aca9f59a1c1b2d"
  end

  resource "patch2" do
    url "https://github.com/AdoptOpenJDK/openjdk-jdk8u/commit/267716c72f8789750f714dc29d4ed1f1f10a4f16.patch?full_index=1"
    sha256 "e7e1512848270a8e3121fa92524f399ae18504a32e97cb1a43eb2075a54f120b"
  end

  def install
    _, _, update = version.to_s.rpartition("+")
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Stage all subpackages and set the path for the bootstrap JDK 7.
    %w[boot-jdk corba hotspot jaxp jaxws jdk langtools nashorn].each { |r| resource(r).stage(buildpath/r) }
    boot_jdk = buildpath/"boot-jdk"

    # Patches must be applied as resources because they assume a
    # full Mercurial "forest" checkout.
    %w[patch1 patch2].each do |r|
      resource(r).stage(buildpath)
      patch = Dir["*.patch"].first
      system "patch -g 0 -f -p1 < #{patch}"
      rm patch
    end

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
