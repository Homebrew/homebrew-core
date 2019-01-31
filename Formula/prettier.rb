require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.16.3.tgz"
  sha256 "bd0c5576328bf8b80407f98f539a302f6547fe4dbe8ef313bba6d1027120ef92"

  bottle do
    cellar :any_skip_relocation
    sha256 "22ed4c90ba994cfa12efdf61d9b56593004d7444906100244eb24236d1c8a422" => :mojave
    sha256 "445d7d52c2aeeb3a322ed37ceec6fb36ac72e50d2a4917b280ec7e58f647f6b8" => :high_sierra
    sha256 "f40d6fe0399f8e89e815f4a2a1d37076f3a56cfc07e9d825a072c4bbfddb8e38" => :sierra
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
