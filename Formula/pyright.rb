require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.304.tgz"
  sha256 "3c0456708be9d8607ce5d58568e14bf52d94ee19383208c6ff45a38eae407b7e"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "983c0064066ef7320dc3236b4c61501dc4442457dd6c5938b238cd6f5c17f2a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983c0064066ef7320dc3236b4c61501dc4442457dd6c5938b238cd6f5c17f2a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "983c0064066ef7320dc3236b4c61501dc4442457dd6c5938b238cd6f5c17f2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "0c1b2e681e43274ede857aa4b1f36aaf4ee127d11f632fff88e1159cffd404f8"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1b2e681e43274ede857aa4b1f36aaf4ee127d11f632fff88e1159cffd404f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1b2e681e43274ede857aa4b1f36aaf4ee127d11f632fff88e1159cffd404f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983c0064066ef7320dc3236b4c61501dc4442457dd6c5938b238cd6f5c17f2a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
