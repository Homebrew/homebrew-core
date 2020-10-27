class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.4.tar.gz"
  sha256 "8ce90c5d05e7ad1da4c12f185837e8a867c22df2d557b0125afaba4b1438e6c3"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/"
    regex(/href=.*?libshout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d79a739ec341a9e39f8b60e36d1109b9b235146dcaa766cd468ab392b107c426" => :catalina
    sha256 "7e06d3251ed6520de0278308c90e33036b7d25efbf370286753bdea69fa000d8" => :mojave
    sha256 "57029eaff39233c54b38d7ca44254423f8ece8c4deaea17514dc53b325065a28" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
