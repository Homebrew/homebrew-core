require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.10.tgz"
  sha256 "cc1a7abb4613cdf5009887730b200b2ebf6bdcb25e2faae15520891d02a3e1f3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dac8bfa699d702eaf95ea6bf5c72eeefc79c250e97ee1247e29ca9cabfa52ac7" => :big_sur
    sha256 "385353847278d790d1fcc9d983d9be6a9f030afca6fcb7d08322aa142169ca00" => :arm64_big_sur
    sha256 "315022f42ab0415052d26b6fc21e0605b4b9b0b9972f87ee415f018505405203" => :catalina
    sha256 "66d07bbbbec37abf0c38a41e7387af0c69f606ba688797e38de6fcb6bfd3da31" => :mojave
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
