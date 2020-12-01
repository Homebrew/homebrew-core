require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.63.tgz"
  sha256 "c1915e420936c9d095990f31cac6d8099aa9af9429f6efe538b3c5ce9fb3c04d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dfc35aeab99b77b891d2f485aca59fb78986a19c7dc1a4f1766287e37720a0fa" => :big_sur
    sha256 "da34148fb8f2253046d5cf19c58b0122a3d489bcffe3164fb9fb36532f402940" => :catalina
    sha256 "ced389062fd6d2f1e282ec5024f8197027d91dd6f7ef503ff5d6a25d73e67cc5" => :mojave
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
