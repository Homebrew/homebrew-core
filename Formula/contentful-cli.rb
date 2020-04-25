require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.23.tgz"
  sha256 "bd25f4fdb50dcfb1256ef6ea14a61f5e0fb53a3eaba18657a7abc6ea07da43f8"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afd29f6a64d9bdb119baebc2d9aeaaa78d55369d221c0b28a021eae65ed2c07f" => :catalina
    sha256 "0751a21dc3244a20a880afa228cbde5f865679f65effc2182d368185c0ffe566" => :mojave
    sha256 "482cc2f8eb3fe1528fb0cec112ba0c351960b5b568032ab2f6855fd40c956610" => :high_sierra
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
