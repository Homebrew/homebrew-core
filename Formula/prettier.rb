require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.2.0.tgz"
  sha256 "45f36cf58d92794a881fde256102aab7fca78754a22370c1dcb4c91c8409a6e0"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "58591ad6bb62bd3e419bc1b302a3929eee06e9735c67633e60693aa15e6b628f" => :big_sur
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
