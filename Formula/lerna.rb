require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.0.tgz"
  sha256 "3421bf7697421c2b3987d1eae83e4093884a00b76033cee0703afda9ba308815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7fb53b64ab8850ed71c40981af6d43dc8213f77908e9c6c74201f6b07c4d88c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fb53b64ab8850ed71c40981af6d43dc8213f77908e9c6c74201f6b07c4d88c"
    sha256 cellar: :any_skip_relocation, monterey:       "4947e805c84e40f6213835bd17d3121392221db2145d604de4fa5758912532f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4947e805c84e40f6213835bd17d3121392221db2145d604de4fa5758912532f8"
    sha256 cellar: :any_skip_relocation, catalina:       "4947e805c84e40f6213835bd17d3121392221db2145d604de4fa5758912532f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7fb53b64ab8850ed71c40981af6d43dc8213f77908e9c6c74201f6b07c4d88c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
