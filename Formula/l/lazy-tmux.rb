class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "7636ba3e3a5fcd856c4e468728ed6c61384ab32553782f1a7ee45b08f3cb89c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1d258070ca59d33909a64e49ce8c91d2868251467a32bb5750cc46105f9ecce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d258070ca59d33909a64e49ce8c91d2868251467a32bb5750cc46105f9ecce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d258070ca59d33909a64e49ce8c91d2868251467a32bb5750cc46105f9ecce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ccac3c5ace98d4ec88b0e507e44f4fdc807157109c02b41c13ceab4af6b4501"
    sha256 cellar: :any,                 x86_64_linux:  "22ac717cce861d15c87e58eba8df950a54a7494735b3395ddcd8209800aae928"
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
