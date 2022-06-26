class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf"
  url "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
  sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af16e90596878170e8235696dd8093a4953b2b5948b054e76ccd1741ce0e47d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "311e481114105723752e9b8d0f99dda4ad2bbbfd0cf9c75498384c2279d6b94a"
    sha256 cellar: :any_skip_relocation, monterey:       "95c822396502343d156c6c1548c8486c9163321fca5a876c4a149b720a8fb586"
    sha256 cellar: :any_skip_relocation, big_sur:        "00685e086c83d1d93a856f35ae56106ac5c19cc4541174040d6d6d71e51bbe75"
    sha256 cellar: :any_skip_relocation, catalina:       "fc18781c090c4b8b7bb7305a864eeb4e6f3f458d8daa2fff96da3bda061fa8bb"
    sha256 cellar: :any_skip_relocation, mojave:         "85c9bd450b0a0d7453584c343fe6770c94f8f3941aaa6f95d735f1923209b6ed"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d71157cd1baddf951e91477b85b533ade99dfe97a5876bb993fe7f6e8336f780"
    sha256 cellar: :any_skip_relocation, sierra:         "3cbaa18692ac53ce98a754d46e07e89d6dddca4bef3bbb312e762abf5a30093d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "27f661ef9546ff113279654e92c08bb8d8ab837f7dc8b308c1a2beeafdcebc76"
    sha256 cellar: :any_skip_relocation, yosemite:       "263440c302dddec69c2140e8df2e4c00a76b76137243e712e8e8756140e0eaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91b89f648c21ae225074e0a9f4e54154b4f2744cc0a37e8421e84ee7ac61a95"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output("#{bin}/gperf", "homebrew\nfoobar\ntest\n")
  end
end
