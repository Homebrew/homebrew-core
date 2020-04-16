require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.15.tgz"
  sha256 "c068b79c1d930b416985a58976f154c8cf1c8cfecf92b74de2152803714eb2d2"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bc5fbecf8a23abd47d4de2ce794a7da867c28955896759067a37d7c6579112c" => :catalina
    sha256 "78f33dc21052c8c6fcb53c928a27945f3d646c618bd2cc94ab51111da19c99b2" => :mojave
    sha256 "3d64bd5c37604dd0100231d77b5f46d937819875c42f8f1611469f5387be11e7" => :high_sierra
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
