require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.34.1.tgz"
  sha256 "5117b489b4a5d41856083bd7228973dbea0ae77ff526384ed0f028d926347974"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9625ae75a2b80382b082ebdedaaf07bf2822cb4068aaeedf8496eeec3341dd1" => :mojave
    sha256 "13b3704abbf8737ee5f9e058f76e695c5f56c652fd925fdf305a96d2367a7823" => :high_sierra
    sha256 "eaa4757286c446c5bfc611554897ba655816a47b4a371ddf88ecdc1a1ec53114" => :sierra
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
