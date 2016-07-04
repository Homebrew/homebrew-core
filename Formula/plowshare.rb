class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.4.tar.gz"
  sha256 "d6bb484fe63a8e9219a3f284a9ad21e260e2fc21aa004eedfcac86fb65e8c13e"

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
