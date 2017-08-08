class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.7.tar.gz"
  sha256 "c17d0cc1b3323f72b2c1a5b183a9fcef04e8bfc53c9679a4e1523642310d22ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b80e06e6ca689befeffdbf8a3f91b17cbe70e69507d45fb6f37629bd62e0ce4" => :sierra
    sha256 "4b80e06e6ca689befeffdbf8a3f91b17cbe70e69507d45fb6f37629bd62e0ce4" => :el_capitan
    sha256 "4b80e06e6ca689befeffdbf8a3f91b17cbe70e69507d45fb6f37629bd62e0ce4" => :yosemite
  end

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "libcaca"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed", "PREFIX=#{prefix}"
  end
end
