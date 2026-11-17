class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.79.0.tgz"
  sha256 "6298c21d0461876b41dca405cf96a6006a4d8170d3df3c6f4a3801fef46a424b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4084e2eaecf491bc10077ced5cf5a72b0b46d75d8459a27116582ed46a362930"
    sha256 cellar: :any,                 arm64_tahoe:       "4084e2eaecf491bc10077ced5cf5a72b0b46d75d8459a27116582ed46a362930"
    sha256 cellar: :any,                 arm64_sequoia:     "4084e2eaecf491bc10077ced5cf5a72b0b46d75d8459a27116582ed46a362930"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "24e0ae6f31a4e78f2042a274a25a69c5bede21ec0988f713b1e30cb35e9b3e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d2e18905355c26c6ad9fee03d621621e96723ba5dd629d0cf1415f6b491c54a9"
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
