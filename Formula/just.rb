class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.6.0.tar.gz"
  sha256 "d33e656843bc280795373249f5f23f2d6c87aee9dd970058a1c6257b2843bd9d"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1c226e2ad664e8b1f023967eaad2805918182d07a92ccc959ea33257787ffb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bb153d96bd5a7ba6920e7abadc12ccfced7909b6c409ddfb271026b1e4305ab"
    sha256 cellar: :any_skip_relocation, monterey:       "9a48c7e8e760180d4e3298f1a47e5be92095976431539afe81c61493cf5e28f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "369e42736acffd58a5cc893f6265cb5abb1a5d492574e77a0fa3167ef8c3048a"
    sha256 cellar: :any_skip_relocation, catalina:       "d5f254414ecef58c46395427710b6ba827d902be5abe0f4af81353e5b754d66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16a379b473e4b458b680a9afd4bd73f17b7f8d98cc1bc200b70b5c0afa73da2"
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
