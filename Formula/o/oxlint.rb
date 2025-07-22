class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.8.0.tar.gz"
  sha256 "238659b1f44e6b62e78e045e893d3b46b2714d986c1a3c7478b088b05d7ca2b1"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6337d70bd828e04cf5eba5742738c9c9efd0dc12c261fe6fa55e60d85a9dc70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216243fca54267e06eb31422db71da4d2fd82286495d32fa0cb2472ff2049884"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "313512bfcd7bd3b0bb5c4ae82dc2a6c6cb9eb9fac55c4eb367aed75a8dbf244a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf73a4c89446a9b2333bbe4ee3d1dd6f82af2e71779b7065aea4d37ccc97faf3"
    sha256 cellar: :any_skip_relocation, ventura:       "32788baa6656e03660e2de5a61033897917810bbbc86bab40eb1d2c7bebad484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a919bfca3d393809165bc4be2d3ff4fce2197c6958446256961ff77b7e0e69f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90bd86140546695ba51d066072f18f98100616381b821b0b581e9016e23d8b60"
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
