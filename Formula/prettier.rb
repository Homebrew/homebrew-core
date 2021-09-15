require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.4.0.tgz"
  sha256 "b30a8845524af505637d59a78a496c37597f37397558ba1b1557bc81e2ecb0bd"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2cb09c254b3de8bf4244334afd36cbd3fc12a793a2888b508c7c69e0cf82b0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "dba56c931ade87ee538b304a62d9cafe768b5cd41c3d39f4996a02612dac5eeb"
    sha256 cellar: :any_skip_relocation, catalina:      "dba56c931ade87ee538b304a62d9cafe768b5cd41c3d39f4996a02612dac5eeb"
    sha256 cellar: :any_skip_relocation, mojave:        "dba56c931ade87ee538b304a62d9cafe768b5cd41c3d39f4996a02612dac5eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cb09c254b3de8bf4244334afd36cbd3fc12a793a2888b508c7c69e0cf82b0e"
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
