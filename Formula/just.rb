class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.0.tar.gz"
  sha256 "e566c333771697d61c6257f61d85fe8ff0a5993e66f050b2d10e80bd99d5fac0"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8243766fc129ca48520e42ec0e6d2e4cfd62c3ecc787c6d26fd3a36c73d1284"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd144649ee02e29cd79efc0f68b7232a0357431e5d8a24b1561e6833787999fc"
    sha256 cellar: :any_skip_relocation, catalina:      "8d4bbc06a798b6b2b288d539703d069e51f1f66de9991d2c5e4da39c4d56429f"
    sha256 cellar: :any_skip_relocation, mojave:        "4a342842b9df63a0602422a32bde90d3687f04e27c6fa2ea0675ffc077839f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772b397e6692047c30d20040f5dad1caea1ece3e8bcad9ba0be0f78a7a2650a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
