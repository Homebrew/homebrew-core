class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://flac-tools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/flac123-0.0.12-release.tar.gz"
  sha256 "1976efd54a918eadd3cb10b34c77cee009e21ae56274148afa01edf32654e47d"

  bottle do
    cellar :any
    sha256 "e9d6f0e34bf00197859eb997f353123f67a75d644ed9a3dba400207a83a18d6b" => :catalina
    sha256 "c1aa5158e16136453e09b384480a6aa4faaefc818c14243a0c4b5359cdab2fb4" => :mojave
    sha256 "ac4ee518533f4b043fd380d0ed6e2077ec410c16acdf952b733df533a4750889" => :high_sierra
    sha256 "f62d8e1f08e8cd5d952f02a35ebcdc921a1295035a2b66e843d80aacb8d9843e" => :sierra
    sha256 "669b5ff8922496fe8abe8b020ef92118847539095a0d281f73b85e965be1f708" => :el_capitan
    sha256 "3bc22230d8e4ed12c794a0784173e576d17cfae249bb87d4540680d3f0483957" => :yosemite
    sha256 "afeeeebde3988d1028452606aaf22ba18379cf59743c4ac9abefac2f86234dd1" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}",
                   # specify aclocal and automake without version suffixes
                   "ACLOCAL=${SHELL} #{buildpath}/missing --run aclocal",
                   "AUTOMAKE=${SHELL} #{buildpath}/missing --run automake"
  end

  test do
    system "#{bin}/flac123"
  end
end
