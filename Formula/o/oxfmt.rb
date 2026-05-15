class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.49.0.tgz"
  sha256 "164ed3a75bc22c4a0a8164dda4dbe3981593573099252eace82b32300f6550a5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40236d20b9060e5591e6a4da1910eb7343dd417c13bf8d0f5e489db891ca6544"
    sha256 cellar: :any,                 arm64_sequoia: "df70298d4427f7fd3db104ac457de27879203d9eeb475d4d0a0894f5338cf4c5"
    sha256 cellar: :any,                 arm64_sonoma:  "df70298d4427f7fd3db104ac457de27879203d9eeb475d4d0a0894f5338cf4c5"
    sha256 cellar: :any,                 sonoma:        "e88ddf67e369bd78c7c29907829829232b2f75a1e863373c30a279fd7937eee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474282681a56d9fe67e174d8b59c2e6a51d518302d5ad26e19329073bdb21fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857413c63194995926906e45ea61a24394beacd24bf9f9eeb4c62a52d4c0ffce"
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
