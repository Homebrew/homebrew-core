require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.3.2.tgz"
  sha256 "f9c9840aac09de4d88f7d8af2957a93dd8bc57ef5bc1f8d5b3984c7c2a509f8f"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7108b6dc5609b87419bfe31d4f7080fddca338a9b08baf4d7600ec34910164b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0bc0660055937a7fea40c6539da39a67cb0ba68e5a9ec83a467aadf8e5df9545"
    sha256 cellar: :any_skip_relocation, catalina:      "0bc0660055937a7fea40c6539da39a67cb0ba68e5a9ec83a467aadf8e5df9545"
    sha256 cellar: :any_skip_relocation, mojave:        "0bc0660055937a7fea40c6539da39a67cb0ba68e5a9ec83a467aadf8e5df9545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b711d5d1de233e59c2c19a8f5e70b69a4fa15e285142b43dd528aaf53dda0e4"
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
