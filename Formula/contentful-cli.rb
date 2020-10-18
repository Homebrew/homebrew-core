require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.41.tgz"
  sha256 "63dbbe38f785cc73619674eaf0dae29d1def607aa47579d492daa44ac5f2879d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a31cf4956ed7eb4229cac30b30b6d657e2f4a27b8b4c6a9f47e8e2fe1d3cf1c8" => :catalina
    sha256 "4132edf7bd92637ed1ff7b13e622ab48bd00e38959578bed4ae0e484eddeb602" => :mojave
    sha256 "9af46b22d95ac01d186fa518d2307907b23e0753379ec59cc81943a3f166e66a" => :high_sierra
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
    assert_match "Or provide a management token via --management-token argument", output
  end
end
