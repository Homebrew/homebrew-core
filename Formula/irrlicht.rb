class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e5b9b3d8b58f26c138b9dcd421fad9769e6ab7833bbf668cdeac909fd204a601" => :mojave
    sha256 "508d300a52f1f1d5b1d5193f07559ca3da5aa3286181ae88b415bf5468c521bc" => :high_sierra
    sha256 "d2236f351b11847d960909fa0e96d83ab0448228de30cd21014fea47a2c636a5" => :sierra
  end

  depends_on :xcode => :build

  def install
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

  test do
    assert_match "x86_64", shell_output("lipo -info #{lib}/libIrrlicht.a")
  end
end
