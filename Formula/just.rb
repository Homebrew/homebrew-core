class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.4.tar.gz"
  sha256 "70c0d6cbc21b7d4e993cd0218d89f82e86498ac86762e785dc2fec6c65202905"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d8599a36a989fc060da5c98569946b127f530c3b3ee78133e1598915d5a3e21"
    sha256 cellar: :any_skip_relocation, big_sur:       "57bff9eff00971dc329bc4dbe61b1da77ddadd017c1de0c3cbba28f5f99c5754"
    sha256 cellar: :any_skip_relocation, catalina:      "b125c993c7fdb3e7ffa1415f09f191a625a395d70ff6a5584eff139f76128c96"
    sha256 cellar: :any_skip_relocation, mojave:        "1fb9c2d34c7905ac05ee397e8a396a391ba03cba86a2d96201375b8da4e3657c"
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
