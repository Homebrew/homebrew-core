require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.18.0.tgz"
  sha256 "d8da7d7f657184861ae086e735851af6d93d6bc3e7197b973f854198f3a13866"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c6f3ec854c86ce9ee3bea78999cb649f0ff7b5c8bf0a8b2e57d0730091463bd" => :mojave
    sha256 "a039fddafdcc0922ecc10134c1345e2d2c53ef0cf6009bc0c58bf489a9e6d1a3" => :high_sierra
    sha256 "d79c64b9e7d6ba3ed0d7859a79dd4c1cd6e0356ea39a2d1b5890fa9dab359365" => :sierra
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
