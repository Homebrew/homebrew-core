class Mrtg < Formula
  desc "Multi router traffic grapher"
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.8.tar.gz"
  sha256 "1ac2e0af69e0ecdef755e798ca59834ab78ac185c2a5effdb7685c58f2ef01b4"

  livecheck do
    url "https://oss.oetiker.ch/mrtg/pub/"
    regex(/href=.*?mrtg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "581c14076645c5902c08c129f76c83cc864ce675f13befe35c31b22c31924735"
    sha256 cellar: :any,                 arm64_big_sur:  "d18d7f28aefcf8a4d927191ea39d7e7180ef0fd6f9cbfa8f78a7c479ae180225"
    sha256 cellar: :any,                 monterey:       "0a675103885fcee03abc942649d4caad174c9df19c0e6ed5bffcc568878a51a0"
    sha256 cellar: :any,                 big_sur:        "07e807ddaf2a41cefd8511bf441c403da9062eaaa4978628d99ee82fc9204947"
    sha256 cellar: :any,                 catalina:       "16df660ec359b69b2459c924b53531e858d5cbf07ae2d182c3d8af150c62274d"
    sha256 cellar: :any,                 mojave:         "f2d1b8898e2cdda752a6456bed569a37a61c48b6d3f881ecc9a8e8ec2543257a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110cdf1481f558df5b6b2438b5087ff0e13d07ee2a287c2bd29617dc431a0843"
  end

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end
