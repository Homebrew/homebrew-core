class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.5.tar.gz"
  sha256 "d9e568668a673994ebe3f1eb5f2bee06e3236a5db92b8d0c487e1c0f886a6890"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/"
    regex(/href=.*?libshout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "3fbcc3aa5f6c9c72e8c1396b3d47c4d68d083f4ec5190317de3dc6e6aee4daa2" => :big_sur
    sha256 "7bc3f07a493342cde56500d1aa972259f24bd3b86cef47ce3c797dd919299b78" => :arm64_big_sur
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
