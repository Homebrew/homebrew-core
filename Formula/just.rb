class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.2.tar.gz"
  sha256 "7be0c7f895191407c70affedc8640fcbc64b50cf72d4d301a1f2391e12478f14"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81075dc8a21e2f4523d0f3c983a8398c5ebb186db8e66a3281f3aa63b39c0256"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcfa0c920ee2385250351275fa2f3271647a867dff97536e1c6f682c79af5b1e"
    sha256 cellar: :any_skip_relocation, catalina:      "0c14bf41f8b54741fec10d20450d1828a0bd7bd01b4a389e56d3bac7e1c7e56c"
    sha256 cellar: :any_skip_relocation, mojave:        "c20538a500aba5489f95ff0d0ec88267952e27de84c0b21426e0c15049d512a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9706501f3468a6ce9a26c9fb71f6d7d5ab715e68b0b8086f928d5b00fac0a37"
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
