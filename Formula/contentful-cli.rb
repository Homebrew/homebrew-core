require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.5.tgz"
  sha256 "09f1fdf05007f2ff13db4a394ee1d0c58f18df4c0f7a44d13ca4b94c6cbea8af"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5040a758822daa9c798f78d561a24f18ddffc453fe937b1779481cdaf910fba1" => :catalina
    sha256 "128ff45e2d116d76c3b2fea5d6f1bca6c5873f9cc9af4d5e35ca554d73b4b622" => :mojave
    sha256 "1b7bef1a9aaac5819b7a3aaf83155d7b776bdc2c08f024161bf5fb7656135c0b" => :high_sierra
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
