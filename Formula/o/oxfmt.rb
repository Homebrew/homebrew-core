class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.80.0.tgz"
  sha256 "26ebb6d43266ebb2625ea49ddc354dfa507fec6f1399be63138ffc1bc05ac0c5"
  license "MIT"

  bottle do
    manifest_sha256 "f98fb87e7d784ae6672f13a939d429a5383b5687f3f048aaa5bc8768a2b756d6"
    sha256 cellar: :any,                 arm64_golden_gate: "da247e0cc53841b8ff79d208a69c358ac61b5aef81c65a05cd9bc3ad93d98585"
    sha256 cellar: :any,                 arm64_tahoe:       "da247e0cc53841b8ff79d208a69c358ac61b5aef81c65a05cd9bc3ad93d98585"
    sha256 cellar: :any,                 arm64_sequoia:     "da247e0cc53841b8ff79d208a69c358ac61b5aef81c65a05cd9bc3ad93d98585"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e693605dff076f4a0d5aaab38e23d1c66a3fdafc67764a30ff90e7578416d455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "814a9a488c774162f31e185755f858d5fe5063421dfc87443e04b96e98547f6a"
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
