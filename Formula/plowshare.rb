class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.7.tar.gz"
  sha256 "c17d0cc1b3323f72b2c1a5b183a9fcef04e8bfc53c9679a4e1523642310d22ad"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3d995918e629820f93c9a6d9e2661c4182ba181d2959306adbbfea1b24af5498" => :big_sur
    sha256 "71fc52474893fbb6b7d0a9644ea1a368a59f91fb59c946052a060a10e493157b" => :catalina
    sha256 "fb3eb1ea28870d541ff8ab28efc057f5cb653ba851a4b794319ff3b0bbf48446" => :mojave
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
