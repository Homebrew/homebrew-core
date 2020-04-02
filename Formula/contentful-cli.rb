require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.31.tgz"
  sha256 "1a567867f99e628c3308b535ce2dbe61881a35a2c6d0b7bebe936b8c3179962b"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "161095d140e336af5a4991f353a95996d48a4785dc835aaefa16b6be246ee609" => :catalina
    sha256 "3c885fb410e0800287007014ab5d90ea43f026701c2cff5bbe023850596ff6b9" => :mojave
    sha256 "25e1c1122d8d251567280416c8deaa8373abbd5e2e214faa47942baf30147b07" => :high_sierra
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
