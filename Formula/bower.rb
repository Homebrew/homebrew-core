require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.10.tar.gz"
  sha256 "1485f6b216cde0e156dc22b576ebcf895b3088930393967c26f5bc30a1ac624a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7086bda09e7699d4feb9c105723fa332e5a97d0af7dbaba799394f95cda46a62" => :big_sur
    sha256 "32480f78d1238505be4d7031e9d39d51a7167fc4ff24b762afeaa6f712915481" => :arm64_big_sur
    sha256 "bc9d7b039ab0f4542330d662ea1af873f1d0313e7216ba5aa179ef6065e1eed0" => :catalina
    sha256 "aa51c9ec9aa6d785ff9973d81d9ece85decf852f3812fe82534f48a9c2f8dc23" => :mojave
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
