class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.6.tar.gz"
  sha256 "f30e346aa4cd31b46bbba69cdd17d3bf879607bc5d67c3c2940f511458d19645"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36673173e45174644cf72af2e384469d175a56c5ec459c77018de99d1e0ae71e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eb9bc401906bc4fab9bed1ca6bd86d313f8976066106e60211d1a4dcbd2a3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "933eb024e40bfbe2af717a1468c89512de2a64a1967b5db2c65b7d6cad72f30e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3b0761c72d403e9c0300e0a184787ccd8ce867ccf897643d67f2cfe167298c8"
    sha256 cellar: :any_skip_relocation, catalina:       "5be9ab8f5d6b5d40f905eb26eca10b5ca272e6c9f3e4897b180174b699aabfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60f236172e67b8464b84ec955a8829a844c98ab0e979c06f30e174e52ae4ede"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
