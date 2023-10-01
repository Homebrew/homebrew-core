require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.103.0.tgz"
  sha256 "09c35a1ad3a0df992661d7cfe00f71b0d2c235798c1ee617cf17fbe7962b9500"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0357bc26dfe72b5f4864a5163196898ecdb7c34bbf91013287f6f4e099586c58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0357bc26dfe72b5f4864a5163196898ecdb7c34bbf91013287f6f4e099586c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0357bc26dfe72b5f4864a5163196898ecdb7c34bbf91013287f6f4e099586c58"
    sha256 cellar: :any_skip_relocation, ventura:        "367dec55b81be2050cd3d8f124fe33ad4e6f1a27d06243acb513680c3d54e270"
    sha256 cellar: :any_skip_relocation, monterey:       "367dec55b81be2050cd3d8f124fe33ad4e6f1a27d06243acb513680c3d54e270"
    sha256 cellar: :any_skip_relocation, big_sur:        "367dec55b81be2050cd3d8f124fe33ad4e6f1a27d06243acb513680c3d54e270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0357bc26dfe72b5f4864a5163196898ecdb7c34bbf91013287f6f4e099586c58"
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
