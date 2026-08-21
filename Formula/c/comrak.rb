class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "af8d045d68a237f6733d05e998e7e5ad9125c93fa101edca75d8065271e5ac2c"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1af75889d55d4c5f9f5fff31aa0fb4062636dc15cbc4d567b85b40e4330b0acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0d421fed47a0ac54fb16063b27f086c4d896b6d4d87e38cd4e2eb01f615b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51ac5cf1a0cfdd13b96465b82121444b2e6f99cf40103202bc954f6ac092a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ae19b3a318f7b2d99371375e19440ca7144e39d264e5c0f118ea3789cfb9e3f"
    sha256 cellar: :any,                 arm64_linux:   "d9729a3b16d53900fa0069d27ee531ace898f1859a2829b9e4af77531f1f4bd1"
    sha256 cellar: :any,                 x86_64_linux:  "0efaf673ca4d1f20fbec12942c954b9f7b8502a69dc753c2b4cc4b6e5605ed9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
