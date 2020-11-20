require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.55.tgz"
  sha256 "8ca2c9b00e94c9b37c97305d775339ab8b92918dc5d10b2ee38bd8549af7c327"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c970601ec9f12699287c0eead16ccef9d14771018eddb7b3e9e9f9e4fa57d27e" => :big_sur
    sha256 "040dbe2ea39cd9d532ba0ea2fb2b9023eb7a576a72b22d03998ce4a58f5b733f" => :catalina
    sha256 "2e865b290078c43037144e9fee03c46ecb7cee2d443e9c2806926b971ef5c327" => :mojave
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
