class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "fea7b92922117ed04b9c84bb9998026264346768804f66baa40743c5528bed6b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75597f4af68c2d0d63ecb2f658539e063f932e2447066fe6ef7f7cf6923e6008"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff08883159e7bf059d8deac38f9a666680a4b73e31b71c31dc9c629c9cce5120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfca190e898f4b5fdee0133d6776a82b73c51dbaac5b9941e392407bff9b64c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "38feb32b03ec606cf4e7732e26442da41f471581802107ac524caf5ed1af1055"
    sha256 cellar: :any_skip_relocation, ventura:        "78dc77770a9153d6956bba6a321d5cf6f21c35bf273d37242fcb372b026d4306"
    sha256 cellar: :any_skip_relocation, monterey:       "399121434991e05925aa9d0bf1cd53b0544ac32035d49f8ec4644c6bff0e4b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1705680059c02905b4838c4e5e15b72ef6dc49c4b849821cdafaf66df23099e4"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
