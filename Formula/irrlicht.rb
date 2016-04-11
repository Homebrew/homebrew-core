class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "http://irrlicht.sourceforge.net/"
  url "https://downloads.sourceforge.net/irrlicht/irrlicht-1.8.3.zip"
  sha256 "9e7be44277bf2004d73580a8585e7bd3c9ce9a3c801691e4f4aed030ac68931c"
  head "https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac38d1aa91367ff3cbf61845028e86547b51803d83ac627653d959d2608ee4d1" => :el_capitan
    sha256 "f3e6427bc2499611b12b5babb907153fdd63c478d9745e59821958644e02f915" => :yosemite
    sha256 "4ef8e3d8f22ed7114223f89b6bc286c3fa9cadb9135d274265f2dce396522d27" => :mavericks
    sha256 "5a68f99034d50ce45afe554a36486be55f435bd6b2ff32c8c0f647a0697b0fbb" => :mountain_lion
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
