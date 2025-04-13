class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.16.5.tar.gz"
  sha256 "9d31acf38def12530289f8a9584051d184bb0c4e641f8fd4e4f9583e0df6d9e8"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ec8900500e7813f29d1185e8f9bc8924d40c3b5152bdf300474b9821fb244c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34fdd43d3f3f3bf544de4673335c3f1d0b5c478987f38ec88778c7bd808ebba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d41277bb1e09327e7b60328c8817c1cb98cf3b951533640fb6e6e93ba2dcabc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdafdb1640f50227a0dc367043ef14a98d17e13e0fff4ae229dd0cbcb3d8acd7"
    sha256 cellar: :any_skip_relocation, ventura:       "8b5ae59c87514f98e842e38461974ec7433505f27a3d311ba41fb7bb0e2f33f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a4264b3d81d57657126169a48017d7d4e2df1a6f05072aaa1d5ea828666aff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76fe124a6bf07779dd2433b077ae01583ecbe80058a008f0c515e03638862c2f"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
