class Mado < Formula
  desc "Fast Markdown linter written in Rust"
  homepage "https://github.com/akiomik/mado"
  url "https://github.com/akiomik/mado/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4105c55801a160563603f22362ea787aa6db316ab7d8dcc19f11ad3242d6283f"
  license "Apache-2.0"
  head "https://github.com/akiomik/mado.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "448837f4ac64e4722e37bf28b6bf3f5f333e3f68e5557765c366309cc523b546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b99bf4e55b934184f5f319d4616e2ef703f604e5f9307e783c1bf95481b9338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93236546d7581e3b7c266dfe2908fe572c1b1dbbdc0dbafec8fcb1467c3fb42b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9844e9042f98bb74cc7c304e961cceb0094c7926b4a6fff2fbb67e2364ebd996"
    sha256 cellar: :any,                 arm64_linux:   "1288541806f7c6661fc14c2c69a3906806915976f2c6bcb733423c3f761db90a"
    sha256 cellar: :any,                 x86_64_linux:  "78a233d748d0cf2fc848329b016def1b4eecc22721b24959cd0e0712f2c57632"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mado --version")

    (testpath/"bad.md").write <<~MARKDOWN
      # Heading 1
      body without blank line
    MARKDOWN
    refute_empty shell_output("#{bin}/mado check #{testpath}/bad.md 2>&1", 1)

    (testpath/"good.md").write <<~MARKDOWN
      # Heading 1

      body with blank line
    MARKDOWN
    assert_match "All checks passed!", shell_output("#{bin}/mado check #{testpath}/good.md")
  end
end
