class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.3.3.tgz"
  sha256 "2f1ecb0ab57a588e0d4d40d3d45239e71ebd8f0190199d0d3f87fe2283639f46"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "34c3eb047777201bc1fd28e71876301232bdecf8ee36d35787e621a412244be3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
