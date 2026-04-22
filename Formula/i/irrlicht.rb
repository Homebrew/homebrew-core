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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a8314699b2d76022efabbfc053bc1b50eb1d0e6c18a0e1744e7e45ecccab9f0f"
    sha256 cellar: :any,                 arm64_sequoia: "ac1612d4a8706ea6a300353422b7e14dfeeec124a1a21afa2da6e58930bc6fcc"
    sha256 cellar: :any,                 arm64_sonoma:  "964e8ca8b0f221dfbc7b84fee7dc436d05e3db20b5f52bdce10f05dd25849c21"
    sha256 cellar: :any,                 sonoma:        "1a45162a1578616ec8bae85d0dc0637969d7ac24fd462bd3ba0901087da8f7fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49171c9452f5c4af632a3dd080122c7f2de63fde6837922009041806912707d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b320467b91ab4658abdd8a6f7a356f2babd5e66be6d4eee2de4a34fe2caf1eea"
  end

  depends_on xcode: :build

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
        ENV.append "LDFLAGS", "-L#{Formula["zlib-ng-compat"].opt_lib} -lz"
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
