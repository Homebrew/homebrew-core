require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.2.tgz"
  sha256 "c2052c741c20158a41dd871687081ad8f85dc41364ab0b4a57cb55f61d8b1484"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2b3da28572cded3fed2fc3a2e64500297fe99c023b1bd8f206cc649cc7b94b4" => :catalina
    sha256 "9251ae3c5a94ccfc0c4b3d518a0428f6bac09307098dda9567f71d8f8dbda0ba" => :mojave
    sha256 "a977cdd4065b55d88164c0febba6cbe239cde92f55b64b6849dc5ad698ef458f" => :high_sierra
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
