require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.0.0.tgz"
  sha256 "51fa3e4422361e8bada9e32ab1ebabfa48a3f07cc7cac4d7b19c60e469345f60"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a5a42b12792af62313b75e142d66fc76ef62409f5c4b89dab48e57f21d5a447" => :mojave
    sha256 "536810c7ce69ddeef1d8d3566189a33f017ed9dd6c3bd4cdbd322d0950acf541" => :high_sierra
    sha256 "e9eae6acb24a7b8e38a66548a7402c0297e03f8b74a6e8900e0c0798b1238d04" => :sierra
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
