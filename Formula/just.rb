class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.4.0.tar.gz"
  sha256 "43286928fe7ec58fee8466191ec47f87555e8c4afd91874146881ff02f6f456e"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365295e8e3ed142f66d7012ec1447ce750ade24493974e00e2dc4ca657f05ec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ee3feee6f55dcf893e1bdc49a4eef56b9c7ff8483b88f69ec0d2fc27ac073b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f981201403e26d51b05ffa5125e44af1f26d0f60a597cceea2de6ede27501199"
    sha256 cellar: :any_skip_relocation, big_sur:        "83b7e6acf1492586b5e7cca2ae932f0e98050f103dadb06ada7551b9c51c6ccb"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed3f8ba8cff0c89fc411ed4beb46bc76825bc3c4c47327792f347dd4a772f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2797e38eb2463f6034e9f8f3c18b76df447a455ab161ac703c56eeb5b0d6679"
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
