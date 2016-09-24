class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "http://irrlicht.sourceforge.net/"
  url "https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.3.zip"
  sha256 "9e7be44277bf2004d73580a8585e7bd3c9ce9a3c801691e4f4aed030ac68931c"
  head "https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc3a35165599455475f307e7c0a5ab9a39737df0fe44ebbc711721a1a3a6dea5" => :el_capitan
    sha256 "778ce6351942a2e36ba3cfb30031cc5e6b7327b626cb37c550409ebb71d9a288" => :yosemite
    sha256 "4389e5f8047158f0ef3ae9c55c03f7a1584a90a0964b8ff4ea4669df3ef741d1" => :mavericks
  end

  depends_on :xcode => :build

  def install
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
