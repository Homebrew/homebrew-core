require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.19.tgz"
  sha256 "f040d1e3e16064c1e2ce67fe73a62b3764580e820e4c6447fede9ec8321cd97e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c814eb251c4c89d168da808d49f4a2f95b97c93d3575b254d507055eef30f61a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c393b0a8692ba88691da3738ac91cf813c822d59d3829d07f3a6a38bc671dc0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c393b0a8692ba88691da3738ac91cf813c822d59d3829d07f3a6a38bc671dc0a"
    sha256 cellar: :any_skip_relocation, ventura:        "86cf7d3d737724031053751fec252970b3ae7a446902779625961b1d5b67d08d"
    sha256 cellar: :any_skip_relocation, monterey:       "86cf7d3d737724031053751fec252970b3ae7a446902779625961b1d5b67d08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "86cf7d3d737724031053751fec252970b3ae7a446902779625961b1d5b67d08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c393b0a8692ba88691da3738ac91cf813c822d59d3829d07f3a6a38bc671dc0a"
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
