require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.36.0.tgz"
  sha256 "a8889d2c4739c698d9ce4165c7d2066758cff5236e090129986dc5c098fa2c99"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59d545a66279d1fe6c37d0f9a487ef1b950d021c7c9dd239608e1e30b28a77d6" => :mojave
    sha256 "5016683d25683b930be30c10299a9e172a1f88cd1079d0c4551a31012903f3d6" => :high_sierra
    sha256 "99bcc3c0d5c6d0e41f314e7bf48610e3c03145165372f7d56e354667b59198c3" => :sierra
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
