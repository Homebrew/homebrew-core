class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "1a301dd58b8a443aeb38fd4e4f80cff411c075024203bbdc2f1bd41c6b7724d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fbdd78ad4fb186daff08a366a1e4f20f5dca6065ff3b9f22ee64c660a904d5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fbdd78ad4fb186daff08a366a1e4f20f5dca6065ff3b9f22ee64c660a904d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fbdd78ad4fb186daff08a366a1e4f20f5dca6065ff3b9f22ee64c660a904d5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "588560324be3ab6c837590524e74ed10a790bb4a88ffb9e7f70c6f3a1cfe0702"
    sha256 cellar: :any,                 x86_64_linux:      "42b8f64c1405d9ed2f3abe5af453372781ff5ba22d2780b2856e3a9324f26c58"
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
