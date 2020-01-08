require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.19.1.tgz"
  sha256 "c766f70d74c9340bdb6a834993634d27e4bedac7e0193e10a969ce155ab8bf1d"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b34674ddb5f4b8147b7add4ca22976db710f9edeef052596483a77083154ace2" => :catalina
    sha256 "f26889cffbc46955b27166275c89e2f8a9921d067981b4764cc82ee7f39b3be0" => :mojave
    sha256 "a617f0a98181130c1b5ee288b218b2f27dbe6acd0445e0f0598fd05419b061f5" => :high_sierra
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
