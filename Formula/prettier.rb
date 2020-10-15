require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.1.2.tgz"
  sha256 "18567729cd5412d74b0c6840d8878d06849cf4014fe4167f92c1ac93e1d23574"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a6c2cba9cc1c728bba5ba5da6c1bc027bc84d55f46412e79c5e765a27931a757" => :catalina
    sha256 "db352c62163a79526804d34dd2b706822c0bf9fe655b8f8a32da6448e589cf16" => :mojave
    sha256 "9c7a4564fdae7ab384e2c191fc6d367040293053e6a91601bfee1ae47b57a483" => :high_sierra
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
