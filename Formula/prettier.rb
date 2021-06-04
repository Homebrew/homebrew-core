require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.3.0.tgz"
  sha256 "760186561469ca249a5d40eb23da734a0053fc3829375a9f9a72d68807cfdfad"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56b4631291f0ee43a70f5b7478fb5e70e299d397847edd180accb680919b590d"
    sha256 cellar: :any_skip_relocation, big_sur:       "94c79734e35421a5fac58bda0612e34c23ba2bb6391baa67bd6217084fd15e2a"
    sha256 cellar: :any_skip_relocation, catalina:      "94c79734e35421a5fac58bda0612e34c23ba2bb6391baa67bd6217084fd15e2a"
    sha256 cellar: :any_skip_relocation, mojave:        "94c79734e35421a5fac58bda0612e34c23ba2bb6391baa67bd6217084fd15e2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
