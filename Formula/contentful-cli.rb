require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.4.tgz"
  sha256 "71bc68460fc699744a1cf57cb8b1f01cd112be749ba8af02ad7b445398d154f7"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6be2a293bddf005f8e6f2efe1210efde3f7929c4245199f564136bcb2b1c191e" => :catalina
    sha256 "c0be6526734d59f8566f9a3f53350c24e48205b00b4cf61126995b7f765ed402" => :mojave
    sha256 "3fcca4afc7e192981ad45d5ebfc3b8cde0ae67e72ae8edaff459f80b33e009b0" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
