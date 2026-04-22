class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.46.0.tgz"
  sha256 "e7651c72b82b7b5d5d6927ddd7bab1ae211ff1576946d465e420bfd8ba59ac6b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "042afffde91fdd79b72c6d7a7b3410b83a3fe5845c04a26a56f19f594ffee645"
    sha256 cellar: :any,                 arm64_sequoia: "ccf9b0f86756e8147752f9cee2c4547eecf68344e6036b83f544d78cbc909e9e"
    sha256 cellar: :any,                 arm64_sonoma:  "ccf9b0f86756e8147752f9cee2c4547eecf68344e6036b83f544d78cbc909e9e"
    sha256 cellar: :any,                 sonoma:        "b458d759cf53e1240da7d63c895aa2683783d50f5943353640957f5559bb7db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01e987a749e2865a27d0fb929ff96469b1345bcf83e95cedf6941441be6487ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8751ecb38911ee2ed42f7e54201cb06763424e4ed6f5a252d3279d9c4a78b95"
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
