class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.76.0.tgz"
  sha256 "556c8448d162c48ed1ed22c50df01d2a8665f5096e15c1189cc968963119906b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "262bdd87eadb55e855f359e15a07508e0d1d026167025ecee0ad45c592e43482"
    sha256 cellar: :any,                 arm64_tahoe:       "262bdd87eadb55e855f359e15a07508e0d1d026167025ecee0ad45c592e43482"
    sha256 cellar: :any,                 arm64_sequoia:     "262bdd87eadb55e855f359e15a07508e0d1d026167025ecee0ad45c592e43482"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "168605c59d7d4b36c1d0cf5e593a291df9f0821f9296cbd29958bf4e224aba26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1b42ab58e898b977391c796bebb19764251351924e4d92e075bb9939d1de1c1f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
