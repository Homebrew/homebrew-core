class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.300.tgz"
  sha256 "cfbaa2bd70265f2c3d7e4094fb5ffaf6f34aafa4b6baaa1d55388fb887ef26f7"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364bdfba69d14cb6b1fcd4db280d96412121a1743f003eca91afa56a687d11d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364bdfba69d14cb6b1fcd4db280d96412121a1743f003eca91afa56a687d11d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "364bdfba69d14cb6b1fcd4db280d96412121a1743f003eca91afa56a687d11d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4f665548beb26f5ce0d26eca293927c724fafc59a57c289d404a98fc142b96"
    sha256 cellar: :any_skip_relocation, ventura:       "4b4f665548beb26f5ce0d26eca293927c724fafc59a57c289d404a98fc142b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364bdfba69d14cb6b1fcd4db280d96412121a1743f003eca91afa56a687d11d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
