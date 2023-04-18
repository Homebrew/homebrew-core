class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://wvware.sourceforge.io/libwmf.html"
  url "https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz"
  sha256 "5b345c69220545d003ad52bfd035d5d6f4f075e65204114a9e875e84895a7cf8"
  license "LGPL-2.1-only" # http://wvware.sourceforge.net/libwmf.html#download
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/libwmf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "bd3df915d0b9d87c94aab7ee63670f911c971c7733d7f4a5b711b65e4d6a05b0"
    sha256 arm64_monterey: "3e48bed98b30b6740c80267498806123a035d100711c6ed8afcb5399dabd2d06"
    sha256 arm64_big_sur:  "544befd86f2efc9ba73b08b2724c0e1951d88c8fe753aa568e442df449d55192"
    sha256 ventura:        "c5c923d66e7954cb488c631bc0dc9f1fa52c1fd5b63d50639d78020db10d88f3"
    sha256 monterey:       "f83417389f14343ca059d9c13c91b01cef4b5fa8ecccee254bbbcf830a6c0c2f"
    sha256 big_sur:        "5886a1a89f5a13f4b1d6e3b9bf5d6d9bbc237833e9ff0347679cf17a6b5d40f8"
    sha256 catalina:       "5a79438b49930e82ab4761644daa03d4843041ed4e245b47a208301a4a88d35e"
    sha256 x86_64_linux:   "a18467741b4b8a3b995017473f8481d46023e36f5af44b28be538aa306007962"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", *std_configure_args,
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-jpeg=#{Formula["jpeg-turbo"].opt_prefix}"
    system "make"
    ENV.deparallelize # yet another rubbish Makefile
    system "make", "install"
  end
end
