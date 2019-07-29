class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.7.tar.gz"
  sha256 "c1efb732f2bc3a80065c5f51a0d4ea6027aebf528c609d3f336aea2055d2f0a4"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "5830af5a88bb0556f417c8138932d8e0a05f037cc69948ec2fa1b78ca69ca1f3" => :mojave
    sha256 "335b723497138e18a8b9b6545c646a72cf4fabfd45aef47959b1a3c37043aab8" => :high_sierra
    sha256 "d0945359761fca563e0a2c42f8283db4d35edfb6c43f9de1865c43a43bd08573" => :sierra
    sha256 "e4df8d0d57062480392e178596d0fba27121af745ba5651a88fd1059330d7129" => :el_capitan
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
