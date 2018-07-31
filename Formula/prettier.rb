require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.14.0.tgz"
  sha256 "00d0f227c712a2da72db1d77d24e01c5221506501cf0856aadb22431edb4c434"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8ad0a3cea0d9cb906986a6201652060b0509a8c987ece7d7b2b8378e1d89282" => :high_sierra
    sha256 "75261eea810825bf1ddc064cea871caffa46a13ec46e25e7d95fbf3514658cd3" => :sierra
    sha256 "5df44611de806b8fce59a8b52afda14f61e416e1c7d4ae0eeab41f83950ee6da" => :el_capitan
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
