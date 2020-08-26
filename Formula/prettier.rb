require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.1.1.tgz"
  sha256 "14c48dfd44af919d21ca01025a8c421c72bfa03712e80593f92a3594959d1ee1"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "424662a92b8278a40ff9b575212c060250b4f944e63c1d33afde620d06f9af1e" => :catalina
    sha256 "582fe60306f19ad67785195e206e350788369dfe444e42291c997cc0d5e7b1cc" => :mojave
    sha256 "ae6d322369444dff0af44b8576cc9978e808c634809e9a1524afdc4cf25a37b1" => :high_sierra
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
