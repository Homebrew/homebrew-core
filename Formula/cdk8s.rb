require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.133.tgz"
  sha256 "b850427cb65d7b4953b30961e463b5f49acb251281759fe8a9a96545a12a129a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e16e4479353503085bba02de40d068cab4f702b09e15849d87e5039939a4fb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27d2d4671fe41931e71f086ae23fc74c6ce8591ebffa8219b26bccadbb2e3bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "851744225957a4e74620332a0f78733852493b59407230ff5c469e3fc8473b1b"
    sha256 cellar: :any_skip_relocation, ventura:        "51d5da82617e6bb82c15858961771cc40da203156ad793743f6e4927fd79f699"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e0e3b65140b0d1571e7aea41be661ffafd9ae6314b742cbdadf335e9becdc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b23fb276e142afdf98abacc97860c5a11b2628a0e929e1422766a51942d4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c0e58178e047ca7b5ff2b42492f9a19a758cbe8ee79a51d6689707303687782"
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
