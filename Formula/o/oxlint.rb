class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.64.0.tar.gz"
  sha256 "9a786243c92438d5a6b4b5775a3b3ddb9c6bebef6d618e1df5095d5fd96f31b6"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e3723c29bd54674e6c53815e676697b10d940947a877265aa7bd83ea08ca497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76fb78e9b81952ab4be640eb693595df94432385af66ee43e648d67885852ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9847a6effd5a3c7944600da4bd9bd644137b585397fad4b7748113bb12649d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "d059d8af3aafa1e859139221a7ececeecbddecd85e419ef3931b5f5f7e6c3b90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609300ed054b0a5d3e8c12933220836157ced9253bb0f51c2973576063f0e74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e131ea57886294995abab13be8b741b85b6763b0fde1d18e3c01c0d2f113a346"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
