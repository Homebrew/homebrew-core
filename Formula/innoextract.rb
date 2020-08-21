class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  head "https://github.com/dscharrer/innoextract.git"

  bottle do
    cellar :any
    sha256 "d3a81822f7925b57904c0c669c4296b3ed0df8551c1cc3039c58341af674bf01" => :catalina
    sha256 "c83524adccf3e591b2e72a7cc72668972f379a9aad9f8a555cc2ce3fa0a90143" => :mojave
    sha256 "92323fd4044aae1db881b3e18ce58b8c51e77a8b745b4e9c120e500cf2cb3ed1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
