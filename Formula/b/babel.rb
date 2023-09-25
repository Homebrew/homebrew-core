require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.0.tgz"
  sha256 "bc165abbc7ce3fada48aa5a7f2d3ae0fb8681c071b600d9c41f78fca22445187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, ventura:        "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, monterey:       "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, big_sur:        "93e4e51d37949a81a239bd3c3ca84893620f07d795ece0b1d90eb40f26652d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d2429b5b69bf7be6bee69f7ae86d7b0524d619d65b4ed052a437cc431bbcd44"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.15.tgz"
    sha256 "6ac27dc7ff329c4c21813e71686734ce57721c8ef39b526a14617a4e1a6e7c1c"
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
