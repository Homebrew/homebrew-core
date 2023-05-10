require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.30.tgz"
  sha256 "bf0a687ad54a589e9e2f4fd223746a32b9ae3f2e1f51984aaf9f2a2257eed02f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f58c1b89215e6690b48d106560eccbcead6c8905acda04bb5d2a245bf64cd618"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f58c1b89215e6690b48d106560eccbcead6c8905acda04bb5d2a245bf64cd618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f58c1b89215e6690b48d106560eccbcead6c8905acda04bb5d2a245bf64cd618"
    sha256 cellar: :any_skip_relocation, ventura:        "52f22c060e2c68de2236d622b1fbf719497ad0f91afece73f834cd2fcdce033b"
    sha256 cellar: :any_skip_relocation, monterey:       "52f22c060e2c68de2236d622b1fbf719497ad0f91afece73f834cd2fcdce033b"
    sha256 cellar: :any_skip_relocation, big_sur:        "52f22c060e2c68de2236d622b1fbf719497ad0f91afece73f834cd2fcdce033b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f58c1b89215e6690b48d106560eccbcead6c8905acda04bb5d2a245bf64cd618"
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
