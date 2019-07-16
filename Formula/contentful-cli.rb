require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.34.1.tgz"
  sha256 "5117b489b4a5d41856083bd7228973dbea0ae77ff526384ed0f028d926347974"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a987e9cb6823d1d0c9be6498ef4418625bb1d5fbc54c2ea47b87b6864435003f" => :mojave
    sha256 "eafcd6539098839db8d3d84f8ecdce1b1d017ef472d692a87104e67da0741537" => :high_sierra
    sha256 "161b3240714613e01fd49ae111a4c531b436fc488b2ac9ce0ac92131a5f64bfd" => :sierra
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
