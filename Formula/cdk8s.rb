require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.40.tgz"
  sha256 "fc88fba438f37637304d9aa342b161965c108c3448550bc0ddf449a6f1b35d17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c980b5fe59f1298ad5b3ad0a542ab247b49904033a26508d5635c5946aba8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c980b5fe59f1298ad5b3ad0a542ab247b49904033a26508d5635c5946aba8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c980b5fe59f1298ad5b3ad0a542ab247b49904033a26508d5635c5946aba8d"
    sha256 cellar: :any_skip_relocation, ventura:        "062c5b36e36d2993a799c6b1699a05e0a111cff6709aeaacc5d3cd1682635268"
    sha256 cellar: :any_skip_relocation, monterey:       "062c5b36e36d2993a799c6b1699a05e0a111cff6709aeaacc5d3cd1682635268"
    sha256 cellar: :any_skip_relocation, big_sur:        "062c5b36e36d2993a799c6b1699a05e0a111cff6709aeaacc5d3cd1682635268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c980b5fe59f1298ad5b3ad0a542ab247b49904033a26508d5635c5946aba8d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
