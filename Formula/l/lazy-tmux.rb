class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "e3d1587680749c930298642f6403ba0ea0c350ff63fb42c0f914915f2d66a477"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f615e63f406ae87d7e2c9429f94fbe7758e3becb0d30e73a64274bbbdd73c812"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f615e63f406ae87d7e2c9429f94fbe7758e3becb0d30e73a64274bbbdd73c812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f615e63f406ae87d7e2c9429f94fbe7758e3becb0d30e73a64274bbbdd73c812"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffbd989a0994fe358c49d8d6b0f8ae2c9de6c55f789a09e3d4e5c745e785cdb7"
    sha256 cellar: :any,                 x86_64_linux:      "6903c94a52e4cb2229bed4ad1265ff24949aaaceda8592a97a4fc6d0712cab2c"
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
