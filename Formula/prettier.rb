require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.17.1.tgz"
  sha256 "8af8ef1b2b54a091181330ea0d67df27f1ff3e2b2958eca2f140f5573cdbd160"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "860aa7cb7536018a2a788aab9571d0668107e8b828ec9debd0355d9d63f61bf2" => :mojave
    sha256 "7a230db140344256227f2a2ed1b589592d7528534c34c56c1253825c5663f405" => :high_sierra
    sha256 "d18f315da66cedcda63ee7a396d7f5451be1e05fe427dd0cbbfabeae06f458a7" => :sierra
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
