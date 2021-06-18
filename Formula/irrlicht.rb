class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/irrlicht[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "394f0bc05d009f151597e258aa8cdbe851609ed16b69211a966f56ca150ddc23"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6de4ddb816d9c40b176e8a8688ae8763058f1f4ae166e0d2b28f5560f451b8f"
    sha256 cellar: :any_skip_relocation, catalina:      "aebe37e4576e3bb2e0d7ba9e5dcad1561db44b093ac97fb30edf4cb0b01192e6"
    sha256 cellar: :any_skip_relocation, mojave:        "44aa81c059704060641612ff44097bcb48f2c5fdc8685aa8ebd12bdc3a7ffa29"
  end

  depends_on xcode: :build

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
  end

  def install
    on_macos do
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

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "libIrrlicht.a",
                 "SYMROOT=build"
      lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
      include.install "include" => "irrlicht"
    end

    on_linux do
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

    on_linux do
      (pkgshare/"examples").install "examples/01.HelloWorld"
    end
  end

  test do
    on_macos do
      assert_match Hardware::CPU.arch.to_s, shell_output("lipo -info #{lib}/libIrrlicht.a")
    end
    on_linux do
      cp_r Dir["#{pkgshare}/examples/01.HelloWorld/*"], testpath
      system ENV.cxx, "-I#{include}/irrlicht", "-L#{lib}", "-lIrrlicht", "main.cpp", "-o", "hello"
    end
  end
end
