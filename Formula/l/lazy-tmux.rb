class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "3442416d6378fd4ca058b0819ed3c6e9c148d74d4bc52a45cbaa11d859f4ca75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ce6ba5e52bbc161c5fec6c03c63649cea550ddad954d2fd603bd5a1789b9882"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ce6ba5e52bbc161c5fec6c03c63649cea550ddad954d2fd603bd5a1789b9882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ce6ba5e52bbc161c5fec6c03c63649cea550ddad954d2fd603bd5a1789b9882"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34211fd01771e77f5f3ca2a1b32fd6410fdc82dcce28f702a1798256d910ea6a"
    sha256 cellar: :any,                 x86_64_linux:      "bde48b3c2a2c771bea9ad220e2774457703f26302bd147669938d6f5578e7a0d"
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
