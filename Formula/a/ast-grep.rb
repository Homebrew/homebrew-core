class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.34.4.tar.gz"
  sha256 "5098df410ffe35444d8d3feba79683793f1b8f5527076563860d5e77cf481b67"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a27b57a69cd180a2f46e8831f489b3a793970e6a655af40e50b2d441b33035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "149b8aa41a2121bf3c454d672e9693685786569555778081783d08cc9f7dbdde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b468702c52bb5fe71b8afa0b16225fd6a7b14ea5f03b10ce04950347dbd309c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1e2d893bacf9ce37322ddcce1d7d8578364e0c48d8947a64ed83b5e1f84491"
    sha256 cellar: :any_skip_relocation, ventura:       "d0c131814f229720a78e33b59b52b4abc27de3c948a4c709d5718da9250a7b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc9d141f34c744f15f7294234aa611e8d1a77b3df4ae8d380e5c4c98a35a185"
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
