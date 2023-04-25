require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.4.0.tgz"
  sha256 "28a4532514b88270abea40ebbf21f3f0ba55466c5d56657e7cdbd439c68f5c53"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ef639ad62200047a98a16515d84e6b3607158753582cd2a4e2246324931644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ef639ad62200047a98a16515d84e6b3607158753582cd2a4e2246324931644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ef639ad62200047a98a16515d84e6b3607158753582cd2a4e2246324931644"
    sha256 cellar: :any_skip_relocation, ventura:        "4d0bf231565875daadd3383d1ecf73d2a1207f7af08a82413b66c7eb27c49e59"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0bf231565875daadd3383d1ecf73d2a1207f7af08a82413b66c7eb27c49e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d0bf231565875daadd3383d1ecf73d2a1207f7af08a82413b66c7eb27c49e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ef639ad62200047a98a16515d84e6b3607158753582cd2a4e2246324931644"
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
