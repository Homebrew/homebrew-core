class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  revision 2
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "c2a3454c2b3c3d39f505df076e63533e20a1cff4bdd523516b35276cf609b284" => :sierra
    sha256 "bef90294c577a445f353c03a0ca5939daaf9c6f8fe50c6bd29bf93fdc61a00af" => :el_capitan
    sha256 "34e96953feb584c54ce1c08ba4e47e4375cdc02571e8e66adb3f295c022cff44" => :yosemite
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
