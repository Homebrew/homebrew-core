require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.15.tgz"
  sha256 "18785482cc0dfbd9c1d8aed90ba8bafa076de3a2a4cf02041a2302025a0d30ce"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "919b1a0e5a5ba2c3c2c714559529fed8ffbd353163933535f2fc70514621d82f" => :catalina
    sha256 "804f36c8fbb537f32a8f757f42189f70044d2a673f4371523ea120aa528231bb" => :mojave
    sha256 "840f78077af36e3e3b329e79c575700921b927741f30fbcf3f70c006107fda28" => :high_sierra
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
