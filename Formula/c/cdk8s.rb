class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.46.tgz"
  sha256 "b76f1d0f31f1f89c1a06b596c9de343b9ffc70384bca1e0a64f82ec66504c411"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79664d57ba77f6bb57bad9e1d35f2fbf7762f02b27fe3a97931f04fe2b60e4e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79664d57ba77f6bb57bad9e1d35f2fbf7762f02b27fe3a97931f04fe2b60e4e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79664d57ba77f6bb57bad9e1d35f2fbf7762f02b27fe3a97931f04fe2b60e4e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "68fe08719d756c1bdf36bde02ca95ca19e67b4468af63889030a5b552e4c8a17"
    sha256 cellar: :any_skip_relocation, ventura:       "68fe08719d756c1bdf36bde02ca95ca19e67b4468af63889030a5b552e4c8a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79664d57ba77f6bb57bad9e1d35f2fbf7762f02b27fe3a97931f04fe2b60e4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79664d57ba77f6bb57bad9e1d35f2fbf7762f02b27fe3a97931f04fe2b60e4e6"
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
