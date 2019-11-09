require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.19.1.tgz"
  sha256 "c766f70d74c9340bdb6a834993634d27e4bedac7e0193e10a969ce155ab8bf1d"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "609cacf6f3e9d9b6bf47ef64521e813ec5afb9f92b29673e718ec1e4c3bc0a8b" => :catalina
    sha256 "c0705ed90e51a852631c055f3bcc8b821c140ea5673d8d82de6c193b0d5e9ff4" => :mojave
    sha256 "3b8b7231cd85a9705cd651c11867192a923ad132b9f2b4c7aa5fc187f3499a55" => :high_sierra
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
