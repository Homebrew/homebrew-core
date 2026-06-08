class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.53.0.tgz"
  sha256 "9333b61729cb476a47aab5fcfa7f518b41d2e5e38c441ba3527012222331ba2f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "547534644588fc6f979267559d1f0e4699256cd2d057285a0c71e66b8ae0695f"
    sha256 cellar: :any,                 arm64_sequoia: "4c3980a6fafac947b97a6f69a6144ddabb6c7f28d45ab07eee83d641113fc01d"
    sha256 cellar: :any,                 arm64_sonoma:  "4c3980a6fafac947b97a6f69a6144ddabb6c7f28d45ab07eee83d641113fc01d"
    sha256 cellar: :any,                 sonoma:        "e351e85e1618e841b8cd4161c753c871b70d89f02038ea27f2e5780679b2f183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af8b0380709c2158f6f692967acff5d35152404a7aa32b2d2228f5290e084a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67b4aec004edfaf98e134db8c4583ada5c1e661a073dd20aa721e7eca5c6d65"
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
