class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.12.4.tar.gz"
  sha256 "8476a17d93ffce9f2ee4e4bf77f9f07131cc842b2992ec81588a224d0d4ca494"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5e9af900c7abdc43c30324ec0c36d2bee34e55ab9d041b477cd4c561eae115b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97cb70738a899652ae7760fc0de06edad3cddffe8cf13a7c0a4a19768c4ce208"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d493e91168ce04b5a471783f4931c29af3fc07ac9f0628c830143a7a352609a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a81ac290e8558f29126c35c79b58d4601d14be874178b458250782541550774"
    sha256 cellar: :any_skip_relocation, ventura:        "18e56cce5c90b0949409281b1bdbe90f57a1c0c3f247d2d2a93a669602afbf46"
    sha256 cellar: :any_skip_relocation, monterey:       "232f8c1eb84c4d2c831ac9ab64b040941a6da3bab04b5b61fc4c05142e400b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51b911cae674f1a9b9e9a97a15ea83fa08c46293f6feba35d69bf77ed3824cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end
