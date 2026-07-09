class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.58.0.tgz"
  sha256 "15ec22243c8c0e25d3d17aa25162390339abd0e3f9d7d73efb75fe1df7eff67b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ec3f9091163e6d9c590ec997c9a5e5ca28254cd43fedaaea89425c9d58524c8"
    sha256 cellar: :any,                 arm64_sequoia: "9ae26eea35e6323f954d68ef03cf440528ba24b9d2389f199c68ffa2b43349a4"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae26eea35e6323f954d68ef03cf440528ba24b9d2389f199c68ffa2b43349a4"
    sha256 cellar: :any,                 sonoma:        "d69a1f6218fecc57150b1e9ac94083c4102cc8a25f3bd871e93705f7d5df1d96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db8686e8e1fdbc6afecdeed45d886d01264975256cc40d51231e173b43e535b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f538031c1e66a2ab5ce94feb6a4346ec119423e15bae63206caada56ca149a73"
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
