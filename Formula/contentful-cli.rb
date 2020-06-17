require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.12.tgz"
  sha256 "3e829e9e28e1e70e2fe387ae8b07625809807fdd3bc37560ae96b038d159f625"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f19a820c996b1c719298c18ec0111540a45789127f1676985aa9e9e37f82420" => :catalina
    sha256 "288dd64913442ead83bfdc1134146b12804ea46bc3ba151daa9c04075e856db0" => :mojave
    sha256 "aee46d7d718d6a5deffd97f82bcb48f8fb91ba242e3de43ea6b70ac6b442434c" => :high_sierra
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
