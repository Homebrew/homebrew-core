class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.10.tar.gz"
  sha256 "e6a869722181f2122a5a223517a2d1f6505d19b8b9d46ffd59c61fb02f472403"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cda97b69cb63427f07875e3e51cac1dd861980bf165c17afca91007cb345259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3ced65136eb04ee75e2f76ea58662b79180bd11a798afc954aacb6e3daed175"
    sha256 cellar: :any_skip_relocation, monterey:       "35ab2d6e018e8fe8ac93d787511341d0f32e8b559c90156ae8fde726b1595782"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d8f5d095f2adf427156eb6cc2d99801da1c0fb9144b4d6a6a031984c12bd5fb"
    sha256 cellar: :any_skip_relocation, catalina:       "758a0ecceb0cd3fe2cf37cb256407f8ef2863dc981d5df5e7c931069a8cf53da"
    sha256 cellar: :any_skip_relocation, mojave:         "5a97c63219f0a142531665ee3450670cd20544ace5940584768ad688ebcc01eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7285ee5dd8fbd6892b2da602fb205e2a65c0fe356c441f5ca625c68538557035"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
