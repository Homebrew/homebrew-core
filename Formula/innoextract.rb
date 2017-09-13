class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.6.tar.gz"
  sha256 "66463f145fffd4d5883c6b3e2f7b2c2837d6f07095810114e514233a88c1033e"
  revision 2
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "87e0929063d004f693b5c7dad597334fdb6282fc2b244c2b859f42e62ef3f613" => :sierra
    sha256 "bc8067405c9d0ce50abcc398dffa9f70bac62e48025cecace2bf3cff44f58974" => :el_capitan
    sha256 "0581a58c46ee032306d8e73c1ed6429b42f0e01d9fc4765ca455b836aae22931" => :yosemite
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
