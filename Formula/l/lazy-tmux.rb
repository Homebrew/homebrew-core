class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "4f1e8066d7b246a2c1fe31e0f9661d56f7870f513ede44a52addc6d0094ad10d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddf35ddc29548d25fa26090ce891fbb1c6c8bcb1e05af267b08f4bec97560518"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddf35ddc29548d25fa26090ce891fbb1c6c8bcb1e05af267b08f4bec97560518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddf35ddc29548d25fa26090ce891fbb1c6c8bcb1e05af267b08f4bec97560518"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7785fed411306057c0d8ef81d1c6f1414d1fe9574ee05ca2130d28aa3c4981c0"
    sha256 cellar: :any,                 x86_64_linux:      "493d4debe8c21420d44913e1a00f3d216c5b17dc2b34b70c2b5b638a93fea481"
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
