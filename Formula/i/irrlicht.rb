class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.5/irrlicht-1.8.5.zip"
  sha256 "effb7beed3985099ce2315a959c639b4973aac8210f61e354475a84105944f3d"
  # Irrlicht is available under alternative license terms. See
  # https://metadata.ftp-master.debian.org/changelogs//main/i/irrlicht/irrlicht_1.8.4+dfsg1-1.1_copyright
  license "Zlib"
  revision 1
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/irrlicht[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8113fe1762137fbcd055dc31d7002e413f730fa502cee505ba2ff91461e4f5d2"
    sha256 cellar: :any,                 arm64_sequoia:  "045c5bc182a699319caede3eda01d1e51487e2bb176ed6609af6f045a3674068"
    sha256 cellar: :any,                 arm64_sonoma:   "52d4ef47d187ba97e3d75832e69650fe4c042019e379b9937c27f6e4864e4927"
    sha256 cellar: :any,                 arm64_ventura:  "d50090b7519be5ae7851a96f142261e094e1ae2bf0da926d2ba4f7f8d334a462"
    sha256 cellar: :any,                 arm64_monterey: "1f80ce9c03a5ebf3220c5d89bf6b99fb710cde5fccacd9d5a6002102a70260d7"
    sha256 cellar: :any,                 arm64_big_sur:  "8c6b7ab06bdcc19d8860114516f77fd58c5afd8b9f5574ed59adb6d9140105aa"
    sha256 cellar: :any,                 sonoma:         "d765836b6a9a4fcfd74a89b04c37a8a49ee15c5983921a0f2b3a19ae54df32cd"
    sha256 cellar: :any,                 ventura:        "4a7427d5a530d10fec547a9ff26aa1a460288a10778db1e4a257650b44359a67"
    sha256 cellar: :any,                 monterey:       "7bd3837250e6ad688a177a8d3cbbab368967e0bd8f55e4971ba8d9700205d78b"
    sha256 cellar: :any,                 big_sur:        "ef94ddaa3dcb668253d03433c09d68806b4437c38c6abfeb6616d30849a18540"
    sha256 cellar: :any,                 catalina:       "9b97a72a9d6a454c512b8d5c395bbc4229e271ae6ec3feecc422bbdeb70a7955"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c164215a58f0194152ec5bc6aaa4b0752fb9208df441cef0a4bba5dac52ae8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972f4d1016a83b88a7c9162695b8f1bce97c0a707f3fd8db11bdb527f7a0637a"
  end

  depends_on xcode: :build

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
  end

  # Use libraries from Homebrew or macOS
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/d16313ce/Patches/irrlicht/use-system-libs.patch"
    sha256 "70d2534506e0e34279c3e9d8eff4b72052cb2e78a63d13ce0bc60999cbdb411b"
  end

  # Update Xcode project to use libraries from Homebrew and macOS
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/irrlicht/xcode.patch"
    sha256 "2cfcc34236469fcdb24b6a77489272dfa0a159c98f63513781245f3ef5c941c0"
  end

  def install
    %w[bzip2 jpeglib libpng zlib].each { |l| rm_r(buildpath/"source/Irrlicht"/l) }

    if OS.mac?
      # Work around error with clang 17
      inreplace "source/Irrlicht/MacOSX/CIrrDeviceMacOSX.mm",
                "(NSOpenGLPixelFormatAttribute)nil", "(NSOpenGLPixelFormatAttribute)0"

      inreplace "source/Irrlicht/MacOSX/MacOSX.xcodeproj/project.pbxproj" do |s|
        s.gsub! "@LIBPNG_PREFIX@", Formula["libpng"].opt_prefix
        s.gsub! "@JPEG_PREFIX@", Formula["jpeg-turbo"].opt_prefix
      end

      extra_args = []

      # Fix "Undefined symbols for architecture arm64: "_png_init_filter_functions_neon"
      # Reported 18 Nov 2020 https://sourceforge.net/p/irrlicht/bugs/452/
      extra_args << "GCC_PREPROCESSOR_DEFINITIONS='PNG_ARM_NEON_OPT=0'" if Hardware::CPU.arm?

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "IrrFramework",
                 "SYMROOT=build",
                 *extra_args

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "libIrrlicht.a",
                 "SYMROOT=build",
                 *extra_args

      frameworks.install "source/Irrlicht/MacOSX/build/Release/IrrFramework.framework"
      lib.install_symlink frameworks/"IrrFramework.framework/Versions/A/IrrFramework" => "libIrrlicht.dylib"
      lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
      include.install "include" => "irrlicht"
    else
      cd "source/Irrlicht" do
        inreplace "Makefile" do |s|
          s.gsub! "/usr/X11R6/lib$(LIBSELECT)", Formula["libx11"].opt_lib
          s.gsub! "/usr/X11R6/include", Formula["libx11"].opt_include
        end
        ENV.append "LDFLAGS", "-L#{Formula["bzip2"].opt_lib} -lbz2"
        ENV.append "LDFLAGS", "-L#{Formula["jpeg-turbo"].opt_lib} -ljpeg"
        ENV.append "LDFLAGS", "-L#{Formula["libpng"].opt_lib} -lpng"
        ENV.append "LDFLAGS", "-L#{Formula["zlib"].opt_lib} -lz"
        ENV.append "LDFLAGS", "-L#{Formula["mesa"].opt_lib}"
        ENV.append "LDFLAGS", "-L#{Formula["libxxf86vm"].opt_lib}"
        ENV.append "CXXFLAGS", "-I#{Formula["libxxf86vm"].opt_include}"
        args = %w[
          NDEBUG=1
          BZIP2OBJ=
          JPEGLIBOBJ=
          LIBPNGOBJ=
          ZLIBOBJ=
        ]
        system "make", "sharedlib", *args
        system "make", "install", "INSTALL_DIR=#{lib}"
        system "make", "clean"
        system "make", "staticlib", *args
      end
      lib.install "lib/Linux/libIrrlicht.a"
    end

    (pkgshare/"examples").install "examples/01.HelloWorld"
  end

  test do
    assert_match Hardware::CPU.arch.to_s, shell_output("lipo -info #{lib}/libIrrlicht.a") if OS.mac?
    cp_r Dir["#{pkgshare}/examples/01.HelloWorld/*"], testpath
    system ENV.cxx, "main.cpp", "-I#{include}/irrlicht", "-L#{lib}", "-lIrrlicht", "-o", "hello"
  end
end
