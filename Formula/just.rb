class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.1.tar.gz"
  sha256 "e60e61d34fdaaa94aa9c4fa6fc4cd5ce07628758db989d15f97ce7b70d36fecd"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f388b34b790b68016f3d4747b13a0b4b93e3d1b7e9ed0ef547980c55f5e4c39c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ec9c96724660c3512e2674006c948af0fbe4a2d04e40babeb2f7c5a84da7d0b"
    sha256 cellar: :any_skip_relocation, catalina:      "5e2d3b2001b134af17acb873189b2463a0da3b24810bb725881e528116816f81"
    sha256 cellar: :any_skip_relocation, mojave:        "c59317a5bbfa00d274f884bddb7369017d060783c1a6bfd84d13a30c2fad74a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c397922197d0dc93e6794ae95c675eb49fcf108be8f30c50b7c1b8b901cb51"
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
