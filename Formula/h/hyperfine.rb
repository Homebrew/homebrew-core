class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "f4b71df3c78e4cf752ca6fb6ebc4b025f7ea6a5ca5c48fea75f8a1fdb4c7d721"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d797e75f328c0e8d5aae214f18640f82cdb620971b207b03105b1b4a25caec63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdef558822250a41bcc15d0ddfdb8edde44a93834abae3c8a33af18047332d97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f6106d336697f7611ba071e98224b1e91a9225e1a40e996f752c1625c5e2da9"
    sha256 cellar: :any,                 arm64_linux:       "629256719d1898bbbdd683a278110076028f1b3274f2749c0d80c90c1d60d838"
    sha256 cellar: :any,                 x86_64_linux:      "1cb9dcf00e6071ddbe0ee63a1e0d06bcfe75b3e130130430b5fda2efa98740fd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "hyperfine.bash" => "hyperfine"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    man1.install "doc/hyperfine.1"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
