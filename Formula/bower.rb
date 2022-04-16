require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.14.tgz"
  sha256 "00df3dcc6e8b3a4dd7668934a20e60e6fc0c4269790192179388c928553a3f7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12dda43e777c9dbd82c5af6679a1017f5d58c881fa032635c4d5d73be32e9a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32480f78d1238505be4d7031e9d39d51a7167fc4ff24b762afeaa6f712915481"
    sha256 cellar: :any_skip_relocation, monterey:       "0aa24b223c340873731442d026cd4722600d0ef614b6361c9f195f39c58ad716"
    sha256 cellar: :any_skip_relocation, big_sur:        "7086bda09e7699d4feb9c105723fa332e5a97d0af7dbaba799394f95cda46a62"
    sha256 cellar: :any_skip_relocation, catalina:       "bc9d7b039ab0f4542330d662ea1af873f1d0313e7216ba5aa179ef6065e1eed0"
    sha256 cellar: :any_skip_relocation, mojave:         "aa51c9ec9aa6d785ff9973d81d9ece85decf852f3812fe82534f48a9c2f8dc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47dabe1136ca6b812906d803a17238002e9049a8b4b58a76a76b1c1f88824c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
