class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.4.tar.gz"
  mirror "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/libdiscid-0.6.4.tar.gz"
  sha256 "dd5e8f1c9aead442e23b749a9cc9336372e62e88ad7079a2b62895b0390cb282"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e62b74dea259346a51a40aef5af06c0ef88ec7b6de98565371b5a9b257a0be7b"
    sha256 cellar: :any,                 arm64_monterey: "dea2303c568083440c68462c35cc616c83b52640596fac2440d1eb3827ff22e3"
    sha256 cellar: :any,                 arm64_big_sur:  "514b36a72418f8c3049768ac1d6ad8b99221deb8d00635c0fd132474b5e9834d"
    sha256 cellar: :any,                 ventura:        "bca3beecd97f989e62862945de9da1c29ec350e2d014dc5d7ddc1c1f1e6323ba"
    sha256 cellar: :any,                 monterey:       "edeb0fe1e99842867995aa8298612843c5102a04aac3be71d6aabdf41c538574"
    sha256 cellar: :any,                 big_sur:        "7ea4638affc7a8943db29b9b1e0889d68451c1919424540ccd0b6f06c48a5680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c901a24b7316aefdb0bea6ed5d8805e3d817b9941d472cb92eabb9354caa84c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
