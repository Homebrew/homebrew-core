class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.5.tar.gz"
  sha256 "4eca773dd08019e370b584773be5bcba3a6af890d637d9cede240cdb20758b07"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a34890b6421417a70a81ffff091d18ccc2299af77a58926c56241beee881932"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90693f2abc0eb79dc099c2e22254631792f21d972428e5c4b25b3566d94ac585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9da023c5173dcff2edabde94dfdc291af3f176c0398c8f7990b7300b41dc3c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d7bfdffa199c5ca5e70c40c2077fb162e0bebeb1639a378dbf448b13834670b"
    sha256 cellar: :any_skip_relocation, ventura:        "c93500072cb11a40ef8cad5de8a35aa448ed0b02056254382bb13cfd1be1453a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2dc2e3f76cb8c17f4af01532334b5ceec34b545946aa77330aa8f42947c6463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec372d29889742e879983004269b89d7d37fcc646f2e6c5d9683a6b107a9d801"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
