require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.20.tgz"
  sha256 "691bd583e2abe1cc3b36ed67f8cb69b060004d258b34e669a063eacbf228883a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbf880a3b8d6f231fcdde8d42d4156a41d6726d976dbea99f7d73bbd4a7771ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "e94c9976b68a11b51c96e0edf7567595178d8a7bce5197648cd37a637101a8f9"
    sha256 cellar: :any_skip_relocation, catalina:      "fff475a5cba451b0814bac2680281cf5b8e32d7bb871ae7fdcb99766f8681ec8"
    sha256 cellar: :any_skip_relocation, mojave:        "d1695917d6702fc6c061be5463c1d6106990f5f1e51a3e3a15cfe8d937d16289"
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
