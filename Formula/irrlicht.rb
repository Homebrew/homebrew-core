class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
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
    sha256 cellar: :any,                 arm64_big_sur: "7c88c45cbe80a489a1881fd3c6bb74d159c9ca7bc7dd5880ad9bb58c91915a19"
    sha256 cellar: :any,                 big_sur:       "4140548f2ba1485fe7d374e13b6a70d39d6855cf5bbf463af621288e955706d8"
    sha256 cellar: :any,                 catalina:      "d9ad006ffc814a0a491d479bfb1232f2d905e8dafebbba1de18ce2c2201a73f8"
    sha256 cellar: :any,                 mojave:        "45479dc7a13d745a69dccf51c8bf1ebc4cc49fda9fb9e2d0f3a5bd0d67c2a091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "153ae52b4f2d95488105918318ebdc9e83ae257eed0a04e893063285da3ac15f"
  end

  depends_on xcode: :build

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
  end

  def install
    if OS.mac?
      # Fix "error: cannot initialize a parameter of type
      # 'id<NSApplicationDelegate> _Nullable' with an rvalue of type
      # 'id<NSFileManagerDelegate>'"
      # Reported 5 Oct 2016 https://irrlicht.sourceforge.io/forum/viewtopic.php?f=7&t=51562
      inreplace "source/Irrlicht/MacOSX/CIrrDeviceMacOSX.mm",
        "[NSApp setDelegate:(id<NSFileManagerDelegate>)",
        "[NSApp setDelegate:(id<NSApplicationDelegate>)"

      # Fix "error: ZLIB_VERNUM != PNG_ZLIB_VERNUM" on Mojave (picking up system zlib)
      # Reported 21 Oct 2018 https://sourceforge.net/p/irrlicht/bugs/442/
      inreplace "source/Irrlicht/libpng/pngpriv.h",
        "#  error ZLIB_VERNUM != PNG_ZLIB_VERNUM \\",
        "#  warning ZLIB_VERNUM != PNG_ZLIB_VERNUM \\"

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
        ENV.append "LDFLAGS", "-L#{Formula["mesa"].opt_lib}"
        ENV.append "LDFLAGS", "-L#{Formula["libxxf86vm"].opt_lib}"
        ENV.append "CXXFLAGS", "-I#{Formula["libxxf86vm"].opt_include}"
        system "make", "sharedlib", "NDEBUG=1"
        system "make", "install", "INSTALL_DIR=#{lib}"
        system "make", "clean"
        system "make", "staticlib", "NDEBUG=1"
      end
      lib.install "lib/Linux/libIrrlicht.a"
    end

    (pkgshare/"examples").install "examples/01.HelloWorld"
  end

  test do
    on_macos do
      assert_match Hardware::CPU.arch.to_s, shell_output("lipo -info #{lib}/libIrrlicht.a")
    end
    cp_r Dir["#{pkgshare}/examples/01.HelloWorld/*"], testpath
    system ENV.cxx, "main.cpp", "-I#{include}/irrlicht", "-L#{lib}", "-lIrrlicht", "-o", "hello"
  end
end
