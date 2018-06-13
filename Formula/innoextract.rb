class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.7.tar.gz"
  sha256 "c1efb732f2bc3a80065c5f51a0d4ea6027aebf528c609d3f336aea2055d2f0a4"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "3ef597b97eebaa9336c73597b7f4dbcec5bfff6fe112524fde4421b34b823060" => :high_sierra
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
