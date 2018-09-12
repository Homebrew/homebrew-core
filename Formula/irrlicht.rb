class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "http://svn.code.sf.net/p/irrlicht/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "73fd50ff1e1270c213c5395eceb3997d0ab3e535b3f62eb256d99b0f612d5ea4" => :high_sierra
    sha256 "bf23da843d21ab650999c6766b20c4940d589caaaaf2b651726a2c09acb472e0" => :sierra
    sha256 "4f75c007fac42d0c5970afcbac919ccf32a2f827ea1d153461a2f6bffb638be8" => :el_capitan
    sha256 "4eaaf9df3b87d34a4ed562d3bedb4a07bbfe8ff069025f3d28000755c09a4d88" => :yosemite
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
