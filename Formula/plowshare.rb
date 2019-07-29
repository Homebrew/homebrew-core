class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.7.tar.gz"
  sha256 "c17d0cc1b3323f72b2c1a5b183a9fcef04e8bfc53c9679a4e1523642310d22ad"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b9099a281503dde8b677db021242fa0e495d036ce2e9b13838badf8ff17caff9" => :mojave
    sha256 "fe966c7db7ceb08f5d9c522c68f332eb87927dccf71b53947824d541ae889904" => :high_sierra
    sha256 "fe966c7db7ceb08f5d9c522c68f332eb87927dccf71b53947824d541ae889904" => :sierra
    sha256 "fe966c7db7ceb08f5d9c522c68f332eb87927dccf71b53947824d541ae889904" => :el_capitan
  end

  depends_on "bash"
  depends_on "coreutils"
  depends_on "feh"
  depends_on "gnu-sed"
  depends_on "libcaca"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed", "PREFIX=#{prefix}"
  end
end
