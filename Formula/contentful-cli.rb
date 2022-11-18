require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.45.tgz"
  sha256 "9beeedd8f252598d38471716548b10dea79774ae48a24ab9435070048b92fa3e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2eea7f63d80828f1d13f90892b61edcd2e6222f5d27fd763914398fb9d6952c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db86d362e7139905cb29ce0dfaaa2211f9a9b049589b9e3da5f4f170c775564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0db86d362e7139905cb29ce0dfaaa2211f9a9b049589b9e3da5f4f170c775564"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4dff6d3810a018b23a436497734f498b22bef5602df0c2a0c442e808a2909b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c4dff6d3810a018b23a436497734f498b22bef5602df0c2a0c442e808a2909b"
    sha256 cellar: :any_skip_relocation, catalina:       "3c4dff6d3810a018b23a436497734f498b22bef5602df0c2a0c442e808a2909b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db86d362e7139905cb29ce0dfaaa2211f9a9b049589b9e3da5f4f170c775564"
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
