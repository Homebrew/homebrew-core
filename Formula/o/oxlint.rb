class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.56.0.tar.gz"
  sha256 "1540800d4afeee3d144614c034f9ecfe637c90b33cd255c1b70fe71c5f62048c"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e8670482530437aea4660c91899a2476d4f2cef001b216f90dbf36c09c6c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3efdb08d416b2cb20b2dd6b9006980be859ff3fd76d51d2b6075ddc97329abb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2768ba59987d0e4d0fba07c455286bdf8f7acb3d9375d636fddb9840490a8f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e72e02b814699d65069074699f13f422f70640c2d851dd3d4e251d603b240ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df28e36c68cbf2087d5e826f14c849d2be16d69d50d6c3ce9b3dbce94d6b3841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12dec84fa43c52f676361580d15ac48e4f06a58aeb23fd47927c5b1fbbbab3a"
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
