require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.59.tgz"
  sha256 "931de653c6c6d595d5352d0fecbe38ac56504edd79ba450b0ab11bbd0a040e98"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ee37893149d714788d3d33abd8edce947e8b16cab047a48b6296dceba5de6808" => :big_sur
    sha256 "4c92d9bb2c1f5a444475c89d3f5c439ab4c26b7d2d91715e1058832f51fd2c2c" => :catalina
    sha256 "dc078cfac8d61faa389d926855fa656e496842f756b454be4a0084f297de350c" => :mojave
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
