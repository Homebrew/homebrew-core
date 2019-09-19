require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.0.0.tgz"
  sha256 "51fa3e4422361e8bada9e32ab1ebabfa48a3f07cc7cac4d7b19c60e469345f60"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01a461a77ad24a839573ad581d55dc88cee4133fdd0bd804dc73500a5ea46b59" => :mojave
    sha256 "96a504b1d8bdfe78aed0a6ee995967226ee6b4663beb0c7521f8e8097c26e95b" => :high_sierra
    sha256 "18cbace5f4ea4e11b329e50b9e95c30051eecd22fa3f95cd3ee70084619e3e83" => :sierra
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
