class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "1a301dd58b8a443aeb38fd4e4f80cff411c075024203bbdc2f1bd41c6b7724d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0771eeb7b408067a7cda97ec2a290faa4c5f10d3d2396bc90525e3dda63cd9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0771eeb7b408067a7cda97ec2a290faa4c5f10d3d2396bc90525e3dda63cd9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0771eeb7b408067a7cda97ec2a290faa4c5f10d3d2396bc90525e3dda63cd9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79401d9d2478955870fddc5015e993110f64998061a469c7f5fdcbede1716da4"
    sha256 cellar: :any,                 x86_64_linux:      "8638b082e78645f6496ce058bfffd50fa1185ee7a5de96c113101b67a6f8d5c2"
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
