class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.2.tar.gz"
  sha256 "bcfc6d1e8d4ce24a23bb5f718c10ddeaa2d5b5975e711c6afb8849a195dadea0"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1bb0682cd23743972f42dc5bd2f1cdfd367b74de8317db71391fb30a39502a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36897ef993450d81f3b3f5a1e4e042a62d079b98f51df593b4e266f6bf26e0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9e6de3e23945865e08783b97c07fc15787928e40293cb7f9223731e9014ebe"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cee4c3bc1e271621b73892e442f573bf20638fd7f6ba56e3c86893aa632c403"
    sha256 cellar: :any_skip_relocation, ventura:        "36d4d6d8ebf8892a37928f277bf9a8dc09c545c6eb591fdead01a1e051daa6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "4a258a4ce376127fcdd475b33af85bf981534abcf8f31fb4cf700cafd0f0170c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a798a601ce7d05bd790ed03bad7c4799093551a2668dc07756f7d37535d5a580"
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
