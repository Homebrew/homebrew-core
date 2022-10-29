require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.13.2.tgz"
  sha256 "b13557671f243099ac8fe9fa52086279f12061fbdd6f2ff9dab8c46cb2ef98e5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b4aa91af02fcecac5e65c2c116df07d1d2e70ac8a525cb333f242feeed3dc2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b4aa91af02fcecac5e65c2c116df07d1d2e70ac8a525cb333f242feeed3dc2f"
    sha256 cellar: :any_skip_relocation, monterey:       "1855ec5278d2a94bdf5c3d6e540e2b0f1cfb562a551ab3a4a211f0eef6a74f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "1855ec5278d2a94bdf5c3d6e540e2b0f1cfb562a551ab3a4a211f0eef6a74f69"
    sha256 cellar: :any_skip_relocation, catalina:       "1855ec5278d2a94bdf5c3d6e540e2b0f1cfb562a551ab3a4a211f0eef6a74f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4aa91af02fcecac5e65c2c116df07d1d2e70ac8a525cb333f242feeed3dc2f"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
