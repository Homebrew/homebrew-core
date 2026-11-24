class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "345b7ef74acaf82ae1867be85c3055972c22cf3a49bc9cfd50d8f9f26a8141ea"
  license "MIT"

  bottle do
    manifest_sha256 "b14ac5c225d6c5ebdea3520010da8612cd7a04a2d841b2787ec58e42132a362c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e307b3e694978608e804dc6e2c98c60b10245c89566d2688b4a3a2a40a1ad9f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e307b3e694978608e804dc6e2c98c60b10245c89566d2688b4a3a2a40a1ad9f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e307b3e694978608e804dc6e2c98c60b10245c89566d2688b4a3a2a40a1ad9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6b22f38002b79b708d85a5767fcd10e266859a2e10f0edc222f57612602d533"
    sha256 cellar: :any,                 x86_64_linux:      "12d6b7f0645ebfa226f77022d1f31cc4ea5bf0aeda222da3e6c7cac1fa283a7b"
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
