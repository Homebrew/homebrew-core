require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.5.1.tgz"
  sha256 "2db9110490a01474032b198cca7e279866bb6dd8bcab3ed81eccfd1478164e6c"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd996a71b2e1512f07ef7ce3dafef701426ffe0308bf68b524acf83dade813f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acd996a71b2e1512f07ef7ce3dafef701426ffe0308bf68b524acf83dade813f"
    sha256 cellar: :any_skip_relocation, monterey:       "92b30ef5c7008873f46908a77a6523be4a22af6bbcca2f3636473a215588e4be"
    sha256 cellar: :any_skip_relocation, big_sur:        "92b30ef5c7008873f46908a77a6523be4a22af6bbcca2f3636473a215588e4be"
    sha256 cellar: :any_skip_relocation, catalina:       "92b30ef5c7008873f46908a77a6523be4a22af6bbcca2f3636473a215588e4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd996a71b2e1512f07ef7ce3dafef701426ffe0308bf68b524acf83dade813f"
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
