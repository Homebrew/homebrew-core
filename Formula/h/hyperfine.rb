class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.17.0.tar.gz"
  sha256 "3dcd86c12e96ab5808d5c9f3cec0fcc04192a87833ff009063c4a491d5487b58"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b6b743957c871d24f93af5fa01d4869b33a7af7c080746f35a93c014260e397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91247b9f88de70b001653de3e50d38f2630fa5b32423f4fe5a1aae849fd404e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d6f6a979b141926839fc0183433b5f2547d4e385c75363798af97450fdd848c"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e4913e349dd834e90084abda438b687c374f865508f60a41e80ae187796004"
    sha256 cellar: :any_skip_relocation, monterey:       "90d6ae718111504bb7b540b852503c3663e498526759debef116fd2ef0b11386"
    sha256 cellar: :any_skip_relocation, big_sur:        "33431a881d78b8c23fbb261c8debfeafae6b612168677dd6e96efd5221ba972e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9893f9956c5dc76e24ee7d8771ad9b49972fcc28194f92f88493045b0eec4bf"
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
