class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "094cfb80e2c099763453fc39cfa9c46cfa423afa858268c6a7bc0d867763b014"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c899ea41ec0754e84e6b95b0a5e369005b90963b6a08dbc6dc7973506e686885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f504dfa63a94e0919ae341dee9fa7a80b309a9c592c937906400a72b375524"
    sha256 cellar: :any_skip_relocation, monterey:       "8b95fe01343f9d6eea4c443289989f7ba4f7e744f77bb71721ef61bc8a70713e"
    sha256 cellar: :any_skip_relocation, big_sur:        "60cff7acb26e5f473e9e93a4fd417a8221614d5d97e0cedbd1fae31e401690a8"
    sha256 cellar: :any_skip_relocation, catalina:       "b9c35b36df17b5c5bff489fb4ab4ea4ebbd13719378023bfad9bb02f6ae9f6bc"
  end

  depends_on "rust" => :build
  depends_on "python@3.10" => :test

  on_linux do
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"py-spy", "completions", "bash")
    (bash_completion/"py-spy").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"py-spy", "completions", "zsh")
    (zsh_completion/"_py-spy").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"py-spy", "completions", "fish")
    (fish_completion/"py-spy.fish").write fish_output
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
