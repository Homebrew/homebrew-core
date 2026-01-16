class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.24.0.tgz"
  sha256 "98c0f54e159dbd380c26eda1fe72fa2b14d05c6f9a719437eb5a90e965b68d8b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb6860e18f86ea43e780742a32e95aa3027a2a9d541d3930541ea29d048c3ad7"
    sha256 cellar: :any,                 arm64_sequoia: "5371a91794753951a2c3bcb0f8ec7188b69561b8b4556c5dff6c4bb2f1af381f"
    sha256 cellar: :any,                 arm64_sonoma:  "5371a91794753951a2c3bcb0f8ec7188b69561b8b4556c5dff6c4bb2f1af381f"
    sha256 cellar: :any,                 sonoma:        "a202592ce1f3f1befc31b828506336b3fa44bce89f6aaf0918d13a4b5b79eaf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc2c90cd7f749886456d697eab2b08492e2876389a4d95277f66c0700481f75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a63a8df68a050f6bc4a96fb2878788af5edb5db5be5da219497906708333df"
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
