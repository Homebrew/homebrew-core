require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.35.tgz"
  sha256 "2791fe2735232bb4ee1f88b580743ac3cc6912561dc81c751b6919a566726ffd"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c2f655dffcba37097fef1c0b07706642d121b4df96994fb16eba98325f4b3b7" => :catalina
    sha256 "5f781f6c104a634167b50e6451d356ca702ed46d5e86963108c87c82775592fd" => :mojave
    sha256 "e28f44a06ecd3db6f6d41d74e93be5d0a1974808580943dc57ad10dc55e50c10" => :high_sierra
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
