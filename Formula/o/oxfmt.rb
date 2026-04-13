class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.44.0.tgz"
  sha256 "4ad834ef255ab9e5a85473e4f15362b2997ea066a033654c3f582a093678026e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cd81b6caad5127c9ec7b3da179909b901466562b0f6b66262d91767d87a2780"
    sha256 cellar: :any,                 arm64_sequoia: "ce77b6fdd6a60b832c1f0761fdc7fcd5625ba9c212f5a12d1eca7e3be00fd1cd"
    sha256 cellar: :any,                 arm64_sonoma:  "ce77b6fdd6a60b832c1f0761fdc7fcd5625ba9c212f5a12d1eca7e3be00fd1cd"
    sha256 cellar: :any,                 sonoma:        "13cf49b8c5700e85ea7482a87da018574d6d0f7175161a9900495f33cab838fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf5b9e1fbc8c7e98132f5a742d305b7121332d7cc98faa5df44d088d7acd7d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb78fadbc1ada2e884f55bbd23362ed9fa640d738e6da617dfd0f947e800de7"
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
