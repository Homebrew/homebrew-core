require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.90.tgz"
  sha256 "39b403ce4037f44ff21083a56879a6f8767fd54aa3e33a4856f1e66606f4bb1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897845b4bfc82a6eea448243bdeb8d79c5ba58a65ee4439e7600fcfdac5961da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "897845b4bfc82a6eea448243bdeb8d79c5ba58a65ee4439e7600fcfdac5961da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "897845b4bfc82a6eea448243bdeb8d79c5ba58a65ee4439e7600fcfdac5961da"
    sha256 cellar: :any_skip_relocation, ventura:        "c2980d4c4aba7fe1d567c9f098adfb227200c6af718048a545a8f909cc737722"
    sha256 cellar: :any_skip_relocation, monterey:       "c2980d4c4aba7fe1d567c9f098adfb227200c6af718048a545a8f909cc737722"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2980d4c4aba7fe1d567c9f098adfb227200c6af718048a545a8f909cc737722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897845b4bfc82a6eea448243bdeb8d79c5ba58a65ee4439e7600fcfdac5961da"
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
