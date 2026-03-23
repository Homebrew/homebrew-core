class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.41.0.tgz"
  sha256 "be78f36bb49b8eefed5cad8baf5e578c99f2c8bda52514ae14e834defb3fe9c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39dc3810b5fbbbbb77d7d2e43842408ef8ee205f0bc512fa0dc8d32936de6467"
    sha256 cellar: :any,                 arm64_sequoia: "37a9e855c2bf6a470df5924d2317a5a1cedeb054021c119a4fcd62b67468fc82"
    sha256 cellar: :any,                 arm64_sonoma:  "37a9e855c2bf6a470df5924d2317a5a1cedeb054021c119a4fcd62b67468fc82"
    sha256 cellar: :any,                 sonoma:        "5c3a32698876ab71115f7f8c9ae9d8b2698adb483b2d8a7087598bc51b15a9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5d40a43067ca227a44fb16e91a71ab893725e4b12643c9f1fc72400f5f8d959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb224b63c5a276692a5d650f080a1419100f9895cd6e7fd390b987e2cdd4db7a"
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
