class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.16.1.tar.gz"
  sha256 "ffb3298945cbe2c068ca1a074946d55b9add83c9df720eda2ed7f3d94d7e65d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fc10af9c516a05fdb41bee042a54b1233b7fbbc762420c4691418fa7ae44d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e5fdeeccd8e1e33e4debb11814b4d6631393e14c0ae0acb789da57c936f3db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e14254ba2959fac01d1749fc2803ce6ed423df62204097e802a4c64d178fbe3e"
    sha256 cellar: :any_skip_relocation, ventura:        "25e9d36240f69a91c52f5e50b2b0195e51c9855690d5a3e1ed4fd61702fbddba"
    sha256 cellar: :any_skip_relocation, monterey:       "d18e905cb2945bf8bb3152ff91db41a83923e4c2c9b0b298ad045ca3a912c6cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d66e5f88231036a4a5f1fe4574b9cdc00a5a465195f54ebaaf4b78a15d843ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ed871b110f168a87521d7fedfe50291ae05df65c253db46ab2e6ce1e4f757f"
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
