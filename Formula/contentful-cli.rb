require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.2.5.tgz"
  sha256 "8cb5543b8548645e3e2eabbfb1de1bc9d4bdbf62037f3f73c386d211a6a76f40"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f07e372cfda2f853c096b9cdf91d5bbb69a4652efdf9a9a04d6251e61ba1ec68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07e372cfda2f853c096b9cdf91d5bbb69a4652efdf9a9a04d6251e61ba1ec68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f07e372cfda2f853c096b9cdf91d5bbb69a4652efdf9a9a04d6251e61ba1ec68"
    sha256 cellar: :any_skip_relocation, ventura:        "5595ef2e70aecde20744f00cf1e0a2bb1e5d6d44637d3231d61199baa5be4fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "5595ef2e70aecde20744f00cf1e0a2bb1e5d6d44637d3231d61199baa5be4fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "5595ef2e70aecde20744f00cf1e0a2bb1e5d6d44637d3231d61199baa5be4fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07e372cfda2f853c096b9cdf91d5bbb69a4652efdf9a9a04d6251e61ba1ec68"
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
