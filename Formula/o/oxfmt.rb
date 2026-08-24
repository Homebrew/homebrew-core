class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.64.0.tgz"
  sha256 "aa82b56a175292ba25bf02e893500452bec12a2c58b1b9372e5479c82b1ff29c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87990e1ea3d9b6ef930fe7cc899bbafcc70aa5f0d8ff007beba44569a9e2a23f"
    sha256 cellar: :any,                 arm64_sequoia: "87990e1ea3d9b6ef930fe7cc899bbafcc70aa5f0d8ff007beba44569a9e2a23f"
    sha256 cellar: :any,                 arm64_sonoma:  "87990e1ea3d9b6ef930fe7cc899bbafcc70aa5f0d8ff007beba44569a9e2a23f"
    sha256 cellar: :any,                 sonoma:        "5bf39b97096ec89654050c47a63a5919c9aee79f69dab306c5f335a3b40424f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829c7971cb058ad527d08284446eddc7d5753e7adc6425521025a8c49f07e4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f369b050cb956f7791329aece026c85d8111893de3013a9d2ec5c93a3a16fb"
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
