require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.3.2.tgz"
  sha256 "612c21a86f7bdbcdd57ce0d1b3f6f205705f5e673310513ebf3f587d63c34cec"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, ventura:        "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, monterey:       "bf27af9f228a7857a92e337e48b8c452b8706dc85f0720b4ff01597672fb83c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c6f6d9aa72c4ca1d1d2b824494ce415a086497821537eb0aed76824de5a68f"
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
