class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.36.2.tar.gz"
  sha256 "f18b3f176308072e6923c19b818167e04f1411dc016fe55b585f505edcec7c6b"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d167ad36744744b571c6ff947c08990f450f3340f80e506614cc1aaba386edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc0c81840f7856aebbc9bd406585978d1cb9ad96faa236f41042159dded7541"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2b61a3201265028c9328a21a1fb82374bac345ff0318e072d2a2abee6dfea03"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94ea109e810159aa8c93d82b1fae6cd2ca012a51e854295b97fa379de906c96"
    sha256 cellar: :any_skip_relocation, ventura:       "e05bdbfaa444034a016897d7169bd77dd8516b5eb8c04d582f20106fb8e1991a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af8cbb1d45530a8f59eb0435c676f6ec84e8339d7d05464ea8e9dad991158814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bcfd05025f2e0b732d049929600b17d04db671eff951e8121c5b021eb88a5d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
