require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.0.tgz"
  sha256 "a3e9e1312222a023c46b841c1a417b64a29fde903f64e4f7e23d0d0e3183bb18"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70733e324341437dcd195d8c8a03554980a3df716a5d8c81fe547e25aea5129e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70733e324341437dcd195d8c8a03554980a3df716a5d8c81fe547e25aea5129e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70733e324341437dcd195d8c8a03554980a3df716a5d8c81fe547e25aea5129e"
    sha256 cellar: :any_skip_relocation, ventura:        "5a673456fae152d1f9a60c8b455b767923ca33acdc1801751120f4329e350b76"
    sha256 cellar: :any_skip_relocation, monterey:       "5a673456fae152d1f9a60c8b455b767923ca33acdc1801751120f4329e350b76"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a673456fae152d1f9a60c8b455b767923ca33acdc1801751120f4329e350b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70733e324341437dcd195d8c8a03554980a3df716a5d8c81fe547e25aea5129e"
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
