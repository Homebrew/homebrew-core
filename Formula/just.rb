class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.11.2.tar.gz"
  sha256 "adf37756f742aee63cb6c1e6e9c4c47ca62e15ca87a41ff8ca5006e6cf059902"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638293d8b38a524a541193c72759f3bf95850c9a32b7d8e3f9ab0f2ee5208d05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf24b7d876d8cb750acc7d24c7c8753846eed68cc3c1ae8d0a21bc25fe67a542"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a9d857ec409bb1997109b28f2f8302e52348b474ae621109065f32591e121f"
    sha256 cellar: :any_skip_relocation, big_sur:        "395b4bec7d25e24bfc5ba4161b91e232f7d2c860e392b1af0e0da2366944e6bf"
    sha256 cellar: :any_skip_relocation, catalina:       "1a7c2b6c62130aefcea0597a66fe311a8b489b97e00341a99afa663d77ef8497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a7314dd22442b1e04b86a07d6bddd9a810bc261bad09d8fb5a41df54be6453"
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
