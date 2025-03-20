class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.23.tgz"
  sha256 "5e7e1b828a3e4e0fbc080640b526d9b443e6f87fa7bed02b89d0aed74f2d0fb0"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da5c3a4c5ce3ca69a3cc8cb6dca3ed8767bce370eae556d003063d469d26d8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da5c3a4c5ce3ca69a3cc8cb6dca3ed8767bce370eae556d003063d469d26d8cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da5c3a4c5ce3ca69a3cc8cb6dca3ed8767bce370eae556d003063d469d26d8cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3fc9f380108e11b9c7493f445c36fea6981ccb0a7a7398439ffe281a63e3510"
    sha256 cellar: :any_skip_relocation, ventura:       "d3fc9f380108e11b9c7493f445c36fea6981ccb0a7a7398439ffe281a63e3510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5c3a4c5ce3ca69a3cc8cb6dca3ed8767bce370eae556d003063d469d26d8cb"
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
