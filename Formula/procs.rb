class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.1.tar.gz"
  sha256 "ce84e98dd85cb8d5afda871ad2ddceb4faec077d9e019469aa668a75821e4fc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1de0a0fb7cd75c1acf101c209b8bc87890595994957470b479dae9d21f0437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af9c8ee5487821a5ed7b3060a141377718ec8854cf9b7835a7002921d82320a6"
    sha256 cellar: :any_skip_relocation, monterey:       "18c59dbde16134202b43a5b85803c4cd777d236a63e59ce04cdca90c15daf02b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f0ee32d30a670e81f66ab228dda9bc5068dbe96723ab5ae378529526978eb16"
    sha256 cellar: :any_skip_relocation, catalina:       "9d9c553980e23ff9fd8a1095bd7126446168d8b91de5d710c8095ef1c5ce3283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d2eca3112bf44ffc81802e345e8b2004082368ac860bb157dbb011fc5ac8e2"
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
