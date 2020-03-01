class H264bitstream < Formula
  desc "Library for reading and writing H264 video streams"
  homepage "https://h264bitstream.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.2.0/h264bitstream-0.2.0.tar.gz"
  sha256 "94912cb07ef67da762be9c580b325fd8957ad400793c9030f3fb6565c6d263a7"

  bottle do
    cellar :any
    sha256 "4b90423bfea6663a9bfacca42403f9cd2f4f5002db79aa04cdee8a80358c11ae" => :catalina
    sha256 "c085b29b8aba3d0a8b80a4bd94292cfdc01af1a19cdcadc5d7394923ab28f632" => :mojave
    sha256 "b671d3f1f37da9a1e095c82cb3cc0229945f202957c36656a49b625e230e1854" => :high_sierra
    sha256 "5542dfab9f67f04540bf57c72720eaaf48a17ebdc20020a7c6b61ee64d41d0c2" => :sierra
    sha256 "cb603960e6eb5ab5f78cc41546c6c4f1bdf53f07fcf7c7af7c4e714ad4b14dce" => :el_capitan
    sha256 "3989d4b3baa711dd6e4db74d74be519ef6661f8e93d62e258252f932f7d6699e" => :yosemite
    sha256 "f26e8535f5007317aeda05e886453604c97abc0e0892ce6975fee09a7900c1f8" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-iv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
