class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.199.0.tgz"
  sha256 "e979ea4477244589e123761a85fce4fa3d3719a2916603d2f38b9201db817a8d"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a985a63a0676de63b128850bcc7e48c83e9774cc777bb190b1b7254d618814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a985a63a0676de63b128850bcc7e48c83e9774cc777bb190b1b7254d618814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34a985a63a0676de63b128850bcc7e48c83e9774cc777bb190b1b7254d618814"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f03e5927655771a77ac7cf4a26dc6c980a1e1f38239d9a685d49b1dc089c69"
    sha256 cellar: :any_skip_relocation, ventura:       "60f03e5927655771a77ac7cf4a26dc6c980a1e1f38239d9a685d49b1dc089c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a985a63a0676de63b128850bcc7e48c83e9774cc777bb190b1b7254d618814"
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
