class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.56.0.tgz"
  sha256 "af5105611d6530a254d152d65ea8c02e987535c8ed6a01491f6a88554c81fe93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e754264d7849b03b3ea5cf02deb088e35d4fd2f43e2905b299d3451fb1c2bc22"
    sha256 cellar: :any,                 arm64_sequoia: "a302e9fff73ccb76da638985e07d417bf79b75955ebced6c02b9158b53e13369"
    sha256 cellar: :any,                 arm64_sonoma:  "a302e9fff73ccb76da638985e07d417bf79b75955ebced6c02b9158b53e13369"
    sha256 cellar: :any,                 sonoma:        "d1f78065dc3628c54b7c944d1161374152f41b0e63294a2ceb5b08d7dab01d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ee9ba330400dd1ffb83592546c69abfea3b8a5b5655027901126f595ada6066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6995531ef4c85da398576cb135b75133317d3325d31452b14700c3f03dcb03ad"
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
