class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.48.0.tar.gz"
  sha256 "f27d451d12bb1dab38c1220166d57165088bfce21a763cc300be7473f1dbf979"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b4cdb5d7ad0cfada7a31ef91c3c9ff4077f7cbc666f5d7649f82aaeb14824d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3856e5d8bb102645a3589ce4fe436135a37d99859b9e4ca5a1ee1f7ae578b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cccc7a952d1074987424ca9e3e25df017c5fad959f1ed1bc51f5ed48b94edf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af9c5ed201d1adaee7c5a5ba759b08fa37e040a3df3f53d39c47b5c5eb0761f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d5df9443ee5605f9733df9546ebb81713ff5d3ec361136f1ae4e296e908d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af10662677357f09d51303ea9f345a6d4912e83381d2f398cc16a37be152b56a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
