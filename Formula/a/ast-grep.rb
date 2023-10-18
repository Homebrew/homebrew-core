class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.12.5.tar.gz"
  sha256 "39c54c1f809340c6f2e9b8f1e941619ec161b076e2114f0140a8e5825259048d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a140244319583f92eb5af669c723b74a1716a269a15b50374656b31fd77e595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed2408ddf22e1c83b2066db2f58c39d5a47f5898b662e1d2f8909fa0312f96e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e0688943f3b99daecd2a98b486923dd3fed4a45cb08cf9baf8b2a60ad3826ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "79f959b072d780bdb73f76bcb2334ba561e41919c93a091f399bc2e0c22b9618"
    sha256 cellar: :any_skip_relocation, ventura:        "c9103be93ad4d0a3d85676e92a5a2c0079bc4d305e6320a9cdf31248305582e6"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3cfe4c854585da88a0cc28a08619fbce1a8636481d7ca9c4176bcd6009a31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79751762fe9185ce8e865543c97eade4276411c5c611d0b7519df78fddfbdc7f"
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
