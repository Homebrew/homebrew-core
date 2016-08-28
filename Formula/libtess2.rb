class Libtess2 < Formula
  desc "Refactored version of GLU tesselator"
  homepage "https://github.com/memononen/libtess2"
  url "https://github.com/memononen/libtess2/archive/v1.0.1.tar.gz"
  sha256 "2d01fb831736d04a9dd2c27cbe8d951f15c860724cd65a229fa9685fafce00fa"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "335bfae9b72f2ba530893c493cc7c4f7738901cb087cc1624b03b0f113e5652d" => :el_capitan
    sha256 "925affe887bcd5388e30e116a7f91da95b3149f4fb2a17ee149f0abf00cbddc9" => :yosemite
    sha256 "fa438ed6e594c08dc226ca93ecc56d4f164f11576328dabcffdd3539a971ffd6" => :mavericks
    sha256 "04ffb8fe1e64575384adb1066c3b0556f75be08e65a194b93b0a1a6f8972fa13" => :mountain_lion
  end

  depends_on "premake" => :build

  # Move to official build system upstream rather than hacking our
  # own CMake script indefinitely.
  patch do
    url "https://github.com/memononen/libtess2/commit/a43504d78a.patch"
    sha256 "2b05d81ae67e121b578d1fceeea32a318628c63de4522aeba341e66a8b02f5b3"
  end

  def install
    system "premake4", "--file=premake4.lua", "gmake"
    cd "Build" do
      system "make", "tess2"
      lib.install "libtess2.a"
    end
    include.install "Include/tesselator.h"
  end
end
