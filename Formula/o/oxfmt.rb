class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.74.0.tgz"
  sha256 "de5196adea5c3f92701c1360add55b3fb97d22a1deecd2b75f3e86d25ffdfe88"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d698a2152a6cab314526007ccea9ebfa210d8029abe30680eba3244c21ced0ba"
    sha256 cellar: :any,                 arm64_tahoe:       "d698a2152a6cab314526007ccea9ebfa210d8029abe30680eba3244c21ced0ba"
    sha256 cellar: :any,                 arm64_sequoia:     "d698a2152a6cab314526007ccea9ebfa210d8029abe30680eba3244c21ced0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74c5e802420caab2cd06213b0b025d6165e1159ae7644590dcb4b2b4ea337294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "104edcb134227297465096b6b30e8e91320cbdec9bb8c4852d11580e3dadca16"
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
