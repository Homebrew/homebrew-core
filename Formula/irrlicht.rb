class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "http://irrlicht.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.4/irrlicht-1.8.4.zip"
  sha256 "f42b280bc608e545b820206fe2a999c55f290de5c7509a02bdbeeccc1bf9e433"
  head "https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc3a35165599455475f307e7c0a5ab9a39737df0fe44ebbc711721a1a3a6dea5" => :el_capitan
    sha256 "778ce6351942a2e36ba3cfb30031cc5e6b7327b626cb37c550409ebb71d9a288" => :yosemite
    sha256 "4389e5f8047158f0ef3ae9c55c03f7a1584a90a0964b8ff4ea4669df3ef741d1" => :mavericks
  end

  depends_on :xcode => :build

  def install
    # Fix "error: cannot initialize a parameter of type
    # 'id<NSApplicationDelegate> _Nullable' with an rvalue of type
    # 'id<NSFileManagerDelegate>'"
    # Reported 5 Oct 2016 http://irrlicht.sourceforge.net/forum/viewtopic.php?f=7&t=51562
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
