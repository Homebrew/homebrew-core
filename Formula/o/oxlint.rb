class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.61.0.tar.gz"
  sha256 "778957177f920bfce7da6af97d5a2c1daae057a95528b1392f489b3f896d00f0"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f052794fb9ddef8fb582ffa0b35462b00933ff0b0e4d98a7b60d852ef23711fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b179438de4033c723c01bf327f793c5fc2eb495c3dfe1b5d69a6fcca0d375f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43bc8f70c17e949ac8451811547c07d910c5fa33dc9d27a71bbe21dfdcb93989"
    sha256 cellar: :any_skip_relocation, sonoma:        "282488e1edea88e132fa96b01ecd4cfb838cbdf728c0977947f7cbd1933917d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6978db67b1d169595e50a0a471fa0118a8a9d08334a82df1695db3f5c29a3a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f70e6b1fae9b13c66c8e340367283e74cceec2852219947db57f5b775a63127"
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
