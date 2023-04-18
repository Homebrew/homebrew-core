require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.3.5.tgz"
  sha256 "5d482c070280104417e01f90f53aeb630bb3a79254abe88786bcb24ed1125839"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b46d0eba6f55c2c18d1403b031824f6297421c89d2f4d1f2d243616c7f0ba360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46d0eba6f55c2c18d1403b031824f6297421c89d2f4d1f2d243616c7f0ba360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b46d0eba6f55c2c18d1403b031824f6297421c89d2f4d1f2d243616c7f0ba360"
    sha256 cellar: :any_skip_relocation, ventura:        "67ca0ac56ff0172efcdc29f855bf41198faef519edae0f876cdc0f4df5212ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "67ca0ac56ff0172efcdc29f855bf41198faef519edae0f876cdc0f4df5212ffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ca0ac56ff0172efcdc29f855bf41198faef519edae0f876cdc0f4df5212ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46d0eba6f55c2c18d1403b031824f6297421c89d2f4d1f2d243616c7f0ba360"
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
