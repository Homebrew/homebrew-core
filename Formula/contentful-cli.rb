require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.64.tgz"
  sha256 "106a8820907f17d90edb255ed0a9fea93f7b9e8039de88637ac28b523b1b9a85"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fab719cd915069ae153714be0c83455b23674916fb027573a3e9d9300c74bf18" => :big_sur
    sha256 "01e56045c3432048fc162ab694e5d851e46634f0614b5452bdf5e0c5931c4f7f" => :catalina
    sha256 "81efe276206b91fd3933320b1a2cc2ddd2150c35936519b25a6d6b590985db79" => :mojave
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
