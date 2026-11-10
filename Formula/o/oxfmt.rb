class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.78.0.tgz"
  sha256 "efcd09f280a59f1bbd8cf961c7e438fe8ae34d9c7531e7b55afa2a1b100e944b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9e0e0f4fdb988c9b207e4b5b75e334bf072062cf17418072667d458cba2736ec"
    sha256 cellar: :any,                 arm64_tahoe:       "9e0e0f4fdb988c9b207e4b5b75e334bf072062cf17418072667d458cba2736ec"
    sha256 cellar: :any,                 arm64_sequoia:     "9e0e0f4fdb988c9b207e4b5b75e334bf072062cf17418072667d458cba2736ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c58c0284ea6c438850f18cddeb70fbae75946a7f542008324889b8d8f0cc297f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1db651781c7780e7af9a6ad980b7264fce915ae60fea0c156ddf5f8508a47bed"
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
