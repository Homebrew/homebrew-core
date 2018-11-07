require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.15.1.tgz"
  sha256 "e15159deb7c47c0b660059ff3947d18d5ce66733effe119d980c23bbd797ec07"

  bottle do
    cellar :any_skip_relocation
    sha256 "a199b4d24f64a59f00a126d153075843b7b1eb67d6d272234ad3a8d3d3d1ad21" => :mojave
    sha256 "c61f4688e7cc3739bd6be61e5f0c6d1a20a3451e93348892a002e195d03f9d7d" => :high_sierra
    sha256 "ada28c750e4dd3c3fb2889d95332a8a215d6079dc7db9797419b03b778965d45" => :sierra
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
