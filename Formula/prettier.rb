require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.14.0.tgz"
  sha256 "00d0f227c712a2da72db1d77d24e01c5221506501cf0856aadb22431edb4c434"

  bottle do
    cellar :any_skip_relocation
    sha256 "b448c8a59127b0989dfed50b1d776f7b40460ab224d104b8108e3cde55ad4e8d" => :high_sierra
    sha256 "57c548b4cd7d3f5409b59b3aae47ef0ca9264075fd04018cbee28ee25d84db8c" => :sierra
    sha256 "24b24f28bd753a7f843d7628a6f49a94a569e4ef6271846527c4d286018125e3" => :el_capitan
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
