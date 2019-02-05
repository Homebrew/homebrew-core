require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.16.4.tgz"
  sha256 "04fb74726f2a78b07072d45b9612d8f3f315fa206bd1494c5088c6ef24f7c18f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cfa80d899d79f1f1fe480d37cd979b6ae3479ee523bc11dafbda14ad8cb1870" => :mojave
    sha256 "43cf0cb2c95ac9872046a47453728a6d193a46229b61629da81ef05f481bd4e3" => :high_sierra
    sha256 "7ba684f3bf8a3f00bbf09e6e0e2d77e4a8292229e2e7b8afe0c35a96c58f28d3" => :sierra
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
