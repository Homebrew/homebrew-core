class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.76.0.tgz"
  sha256 "556c8448d162c48ed1ed22c50df01d2a8665f5096e15c1189cc968963119906b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b880a115221b3fdc86ec81fe4869cbace57348a78458de1b095a2e6106ef39a1"
    sha256 cellar: :any,                 arm64_tahoe:       "b880a115221b3fdc86ec81fe4869cbace57348a78458de1b095a2e6106ef39a1"
    sha256 cellar: :any,                 arm64_sequoia:     "b880a115221b3fdc86ec81fe4869cbace57348a78458de1b095a2e6106ef39a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd86374489bba9ccc68c5e720af7bff5216ba82309edfe8c337d9e793e8ae1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "db94c2cc5f6739c4514c00d32979e9c338db2588e959555f0b848622d6b5931e"
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
