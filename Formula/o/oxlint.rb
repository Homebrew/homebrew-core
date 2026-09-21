class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.83.0.tar.gz"
  sha256 "9f4540efd8e95068d26e277b7c6433d76bf788f15b4670317fbcf26c75b707fb"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d80c28fa777dc2a446fb9ef9fe57a970623d156a53751067c0e074e675e791c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2920a05c7c0a887de7d7b1210e4129264a76480d8aa3e930eb79acc6c870955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dd0124d6079d87e69cc8f1ff1b2945c5d52bf4c002889549da5ede03647f963"
    sha256 cellar: :any,                 arm64_linux:       "e3069820d524408d992bc81cf0c07538b28ecc6a454ac16961b7f2e22aacbbf1"
    sha256 cellar: :any,                 x86_64_linux:      "530c3ca116d2c7f0acfcf8d7f415d5d11bdeff36caf5f39fb52f4ac589a03332"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
