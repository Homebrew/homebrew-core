require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.0.tgz"
  sha256 "bc165abbc7ce3fada48aa5a7f2d3ae0fb8681c071b600d9c41f78fca22445187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dec96d759c77f49e5b939eeb682f0a93acbc07616f24e612e3f1ef54303200e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dec96d759c77f49e5b939eeb682f0a93acbc07616f24e612e3f1ef54303200e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dec96d759c77f49e5b939eeb682f0a93acbc07616f24e612e3f1ef54303200e"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f73f987fb97c86e94e9e6f258d58a35e1fa1e767b12633d2c547987d199a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f73f987fb97c86e94e9e6f258d58a35e1fa1e767b12633d2c547987d199a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f73f987fb97c86e94e9e6f258d58a35e1fa1e767b12633d2c547987d199a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898cd4eb1402795f4ce111c17e17458c022e1f8a6ae863e77218990e31b47e6f"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.0.tgz"
    sha256 "3c47bb2c36fd66e39ab5c62bdcf47b20dadcd62fd45ad62c2d1c1699af23c2b2"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
