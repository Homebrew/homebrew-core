require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.5.tgz"
  sha256 "6d8af960b3a47645bc897da4bbbf6923de82f7809990cf44e8e4d8077828893f"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1e20fc9be32da04ea3a5d5dbb4153a4589689a2ec5c1a696b0ae01d4c77422b" => :catalina
    sha256 "527a6b93bded9ee87b89d8fbb9b9116fcb5e93924e85189630754acf48565efa" => :mojave
    sha256 "26a0d0f1879743b66781123895941cb849b38a636be3213dd0dd2ed0b2685250" => :high_sierra
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
