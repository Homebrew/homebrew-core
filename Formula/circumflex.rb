class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.2.tar.gz"
  sha256 "6a2467bf6bad00fb3fe3a7b9bdb4e6ea6d8a721b1c9905e6161324cfb3f34c01"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f87e23f7e960ab3286fbea050e7ae77417595f573f09e2f6d087b56ba7cdd9ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d6755e65e975dbbbf4f378189a2b40ba55febf9745ebbea1db99e18ed56d84"
    sha256 cellar: :any_skip_relocation, monterey:       "ec541ca5f50dc8978ee40d95da005062b09926b593e827c8beee899d102aa555"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a71437d81f1e276b79a847521528ea4b4af711111e442170aaceacb9af5b6ac"
    sha256 cellar: :any_skip_relocation, catalina:       "325e90871bdbddf40d3d6a0d9a1191ae2dcb179e4757edc37f5be7a95e2d7358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dceec61ad5863347b2b7e18aa069a55ce0aff0822fed7ba3e6e177b09d3e5e83"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  depends_on "less" if MacOS.version <= :big_sur

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
