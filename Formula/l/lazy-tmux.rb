class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ee750d71f32861013cb758dcdb281490090682f1ce3fb70bc516b2b0ef82d7ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99a43aee2fa12efeb8e6c6f45d68f009b2e56f322084d6efa778ef98d1b49a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a43aee2fa12efeb8e6c6f45d68f009b2e56f322084d6efa778ef98d1b49a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a43aee2fa12efeb8e6c6f45d68f009b2e56f322084d6efa778ef98d1b49a3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26443d14b39efc38efd500438f845d28df8686b3a9e3a2ce0628d185669b1b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a191913c3fd6b76633ccd17562706a5f00a8aede8bc5a89baf0b2c4f56a28017"
    sha256 cellar: :any,                 x86_64_linux:  "54708804bcdd589b01000518e4297b07128e5d40ce2103c3b508e9c006837dc9"
  end

  depends_on "go" => :build

  depends_on "tmux"

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
