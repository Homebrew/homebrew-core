class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.78.0.tgz"
  sha256 "efcd09f280a59f1bbd8cf961c7e438fe8ae34d9c7531e7b55afa2a1b100e944b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "132af25cb96e528a8fa5a07cdcd5bdd1847047ad1a4e5e329540db0fa3013a7c"
    sha256 cellar: :any,                 arm64_tahoe:       "132af25cb96e528a8fa5a07cdcd5bdd1847047ad1a4e5e329540db0fa3013a7c"
    sha256 cellar: :any,                 arm64_sequoia:     "132af25cb96e528a8fa5a07cdcd5bdd1847047ad1a4e5e329540db0fa3013a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eab7e633459d2932559baea1fd960a04c6c2b6190f90706752d51b20d30d44de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "51e16454ce538e267500ac66da1591b031b3a5b3ddaf37d9bf6a459d886e7c9c"
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
