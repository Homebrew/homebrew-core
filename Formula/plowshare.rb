class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.5.tar.gz"
  sha256 "31a1d379b738b007ff000107b03562bf73ed5f05d7fa1ebef50082f0799a59ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe1496232d6c45a79a81454e82b2dd21d3790978d60c836d3edc189bf5f2d880" => :el_capitan
    sha256 "a2f3b29825642936b27bc25023632bdb3123801fea2e78cb4118753c6e055781" => :yosemite
    sha256 "53f41fc14ff8b13ba52912e3f9b104adfaafee29d701563eff83a8578da62387" => :mavericks
  end

  depends_on "aview"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed", "PREFIX=#{prefix}"
  end
end
