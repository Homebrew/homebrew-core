# NOTE: The version of pstree used on Linux requires
# the /proc file system, which is not available on macOS.

class Pstree < Formula
  desc "Show ps output as a tree"
  homepage "http://www.thp.uni-duisburg.de/pstree/"
  url "ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.39.tar.gz"
  mirror "https://fossies.org/linux/misc/pstree-2.39.tar.gz"
  sha256 "7c9bc3b43ee6f93a9bc054eeff1e79d30a01cac13df810e2953e3fc24ad8479f"

  # The stable archive is fetched over FTP and there doesn't appear to be a link
  # to it on the first-party website. As of writing, the homepage lists an older
  # version than the README, so checking the README is likely our best option
  # at the moment.
  livecheck do
    url "http://www.thp.uni-duisburg.de/pstree/README"
    regex(/This is pstree V?\s*?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9733dc8a9d384a122e5fad0b21a33142bef94cf85e2a0cb02e66753fd316a133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "871eebe7b12c62d1086c8f1b0b8802d7a50d2080646e6c64b9b95fd1e3e6f8fc"
    sha256 cellar: :any_skip_relocation, monterey:       "e95fdd5babd994999a697905d0f006878f558d83cc5438e608be3da6add2e71d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3f51c55862f554dfc3e3d70ffb435f6999c5b5592625ef4562633d7ffaed82"
    sha256 cellar: :any_skip_relocation, catalina:       "af4d6c7d6bffd6e12d3cb31ceb6bdd5292b66405ddd1be3a48870373829219a7"
    sha256 cellar: :any_skip_relocation, mojave:         "27b643077e6fa2e233945f505b024f3e725ed8b930bdd89a9df73817197acbea"
    sha256 cellar: :any_skip_relocation, high_sierra:    "426d5701e835bc1f9313c3b7cd630aa0f2b279ad5f95406bd73f50d174e8eaf1"
    sha256 cellar: :any_skip_relocation, sierra:         "063d2498a346002265c44bf9ad237ae47fd9923a10dd529575640d7d63bef2fa"
    sha256 cellar: :any_skip_relocation, el_capitan:     "624458274db8e826c170121061ad25547c5a245788c8108bd2bf0af4a3678dea"
    sha256 cellar: :any_skip_relocation, yosemite:       "127b605bf4b20cbddf63f875bd15f78ad5fc31eaebb57d9ce2051a3b856a8bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155f6be24263c4a454735605462b6281af661d1dd928621fa94a7d287c5af90a"
  end

  def install
    system "make", "pstree"
    bin.install "pstree"
    man1.install "pstree.1"
  end

  test do
    lines = shell_output("#{bin}/pstree #{Process.pid}").strip.split("\n")
    assert_match $PROGRAM_NAME, lines[0]
    assert_match "#{bin}/pstree", lines[1]
  end
end
