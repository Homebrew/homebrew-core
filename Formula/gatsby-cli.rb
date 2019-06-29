require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.6.tgz"
  sha256 "8e8ca5d1cdc99ac1242cc1a0449c877ff28468c3d39b399347e5c1a8647e98b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "01a131161f5ed50ed9a2dba73c9f7b92ba393ea158be164749edb743b6ad7147" => :mojave
    sha256 "f7122264093bcbc864cb7e8c8e2067cebe51a5dd190305ec513b3f5ff1cdbe71" => :high_sierra
    sha256 "b406e1effc7858375b36ab591d6f9cdfd95a5bba23548f4df1dcee26bc78904e" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
