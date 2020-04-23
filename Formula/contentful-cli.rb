require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.21.tgz"
  sha256 "6130c9d4ac06642a43ef67c6e6cf0aa651004df5f6474814c2c3164c20e7c72b"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc65ee338488f1a7534a9bc400ab571b0286e27c1d337c3b80c26775bcf3e068" => :catalina
    sha256 "2ea2622a4e184802ae215f4abe9871824847c1a5ea5c82a5d7b7fc28fa4ac12c" => :mojave
    sha256 "ad61fdf4f87015e1638a2c0b29e42fafb45f61fbb13a72fa3147a3d4c1721755" => :high_sierra
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
