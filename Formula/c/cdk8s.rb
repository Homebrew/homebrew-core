class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.102.tgz"
  sha256 "d487ebbe4043b99962802d361348236e942979c113e01e27777497eede59f165"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020b9f32e03a867ff111051cee612ed5ab471772606ef35e001945cc9dfcadcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020b9f32e03a867ff111051cee612ed5ab471772606ef35e001945cc9dfcadcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "020b9f32e03a867ff111051cee612ed5ab471772606ef35e001945cc9dfcadcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e09a0347815cdc8e30b6a9b9b35e7f89e5d3b2cec5ace8fefa345320871d63"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e09a0347815cdc8e30b6a9b9b35e7f89e5d3b2cec5ace8fefa345320871d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020b9f32e03a867ff111051cee612ed5ab471772606ef35e001945cc9dfcadcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020b9f32e03a867ff111051cee612ed5ab471772606ef35e001945cc9dfcadcc"
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
