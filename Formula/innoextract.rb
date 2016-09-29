class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "38470781a26450fe20ccbb1718e387e644321e3ce7f904c72a70451d7b7cc033" => :sierra
    sha256 "0e9fb5ed9c1a8d475ad8539f89abaf834ecfdc3734b8605bb4fe15ef0dc0aecc" => :el_capitan
    sha256 "ebca784ee724f843cafd76fd2d9226f9c81675a4cdfc9fc67b6cbff93149df39" => :yosemite
    sha256 "292b31136421aeeff77ee6492b389126de1a440c57676a5af1de3b143a78db91" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
