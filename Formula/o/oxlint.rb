class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.60.0.tar.gz"
  sha256 "6fdf2a92c26fa9a9f786257abea9822592ce5d3b9353af8e4592ce968a17e294"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98efe8fc1f6086ce029881c4ca48e3bfaff2d4a28c1c03feb8e7500fc23e3234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc813336c2adbb7a9985408bb9dc5edf938706cf812b6ea126108cf1f20594f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de224d6cb711365703f715d8d2398a2a0d5c318badfa51eb43013537ab16c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e06808ab857e403cf791daee1877e88b16cf65354f18d69895d59cf42c4d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be416d8f5083f0f56230bb602324114eed949ea79b68b48e7c1764731690bc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11980852208526bb0c8372566b0c1bec9c217c6f2527ea93f439a727a91d2cc0"
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
