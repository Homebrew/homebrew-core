class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.25.tgz"
  sha256 "986b99a0e40d180c218372329e76f70793f9e5391fd365e2e02b2bd8075ffdae"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b690bda0faedc71d843226963ecb77054a213679a67bbc9f20764326ce45386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b690bda0faedc71d843226963ecb77054a213679a67bbc9f20764326ce45386"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b690bda0faedc71d843226963ecb77054a213679a67bbc9f20764326ce45386"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb1f7b0fc04d1997781a7c8f2927acb21442c8f3a14ab0299068cb3bc0b932f"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb1f7b0fc04d1997781a7c8f2927acb21442c8f3a14ab0299068cb3bc0b932f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b690bda0faedc71d843226963ecb77054a213679a67bbc9f20764326ce45386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b690bda0faedc71d843226963ecb77054a213679a67bbc9f20764326ce45386"
  end

  depends_on "node@22"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
