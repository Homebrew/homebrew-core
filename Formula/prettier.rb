require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.1.1.tgz"
  sha256 "14c48dfd44af919d21ca01025a8c421c72bfa03712e80593f92a3594959d1ee1"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1ea6631eafa826bbf238e3d36c62c206371bba3beec95589090b7310d8572f83" => :catalina
    sha256 "e83b9d633ca5f53f28aa9eaee46198064cf2485ec6a60d237dc63a23158d53aa" => :mojave
    sha256 "98f993cebe29a9efdc42132ff3e5bb5d12d89b9871908b6a59f3339771b15575" => :high_sierra
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
