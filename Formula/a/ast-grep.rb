class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.38.7.tar.gz"
  sha256 "25d3bb27900b36109002ca59aa5ccbccf96328289ac1970f610c1f30ee6a8199"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e87fd970f2d3e06c2bdd407cc637c892c2097b96a507aaab1030acb3ba8f42e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc775d62314a50516c7fad43a34acf87ad0a240fae2124932a81eb6783ea2ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6769b28868597ceed120bee658bfbd4f3e4bed4f611bf1bbe28b834ebfbc352"
    sha256 cellar: :any_skip_relocation, sonoma:        "76335f53776d0d2fe935e215ac0c13e472cf371b8b50121796291c11fcd1238c"
    sha256 cellar: :any_skip_relocation, ventura:       "08e0bc8f3807b8dc7252860501d72f068d0eb91a977c1e3fa55ababc12517582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b07fcc8d773d02a90c1864567026a67adac207a7f0949d88cddcad0fb38c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2307bba290ac887736fd3fa9ef6bfcc0f2e3c6868740eb102261949cf6fa692"
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
