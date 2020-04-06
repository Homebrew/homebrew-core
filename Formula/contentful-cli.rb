require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.2.tgz"
  sha256 "6ce7137a14605fac5e3a69e60ad738a3c73856a14f32e3deb6c7980c4af2f345"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abe4de6a62501e9fbbb2c7f4532e0dc964c6f7f42ab92c9de70b514494153874" => :catalina
    sha256 "e3dfb9cacb8ba3cfeddd7d0be9dc0f0d1a22be28a15450bcc1b59de1fa31cc27" => :mojave
    sha256 "1c20b0564a90c38a7fe700cf4e00347e7d3fa816db4eaa38972ce47148733d92" => :high_sierra
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
