class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "345b7ef74acaf82ae1867be85c3055972c22cf3a49bc9cfd50d8f9f26a8141ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9067f86dcb9433b82495b1232292344716dd9035a786b0570316b7714cd73a3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9067f86dcb9433b82495b1232292344716dd9035a786b0570316b7714cd73a3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9067f86dcb9433b82495b1232292344716dd9035a786b0570316b7714cd73a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05abda15ddbfc94274f9d660f4fbeb0f9d4bf52696acfaf6e7d98416c4888ad0"
    sha256 cellar: :any,                 x86_64_linux:      "593c1d14d088e4badaaefb84838b06fb72f78e6a6b128a31d45cd9dfec5ada7f"
  end

  depends_on "go" => :build

  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/lazy-tmux"
  end

  test do
    config = testpath/"lazy-tmux.toml"
    ENV["LAZY_TMUX_CONFIG"] = config
    system bin/"lazy-tmux", "config", "gen"
    assert_match "# config source: #{config}\n", shell_output("#{bin}/lazy-tmux config show")
  end
end
