require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.12.3.tgz"
  sha256 "cf750385d9aa2293da3ea87f9f5f067b761c701c5263fdf5a7e8bf2a040c9b8c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba5b8e53e095c31190d725d5b1bfc8292d6f73da31da893bd257e6fc71747d45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5b8e53e095c31190d725d5b1bfc8292d6f73da31da893bd257e6fc71747d45"
    sha256 cellar: :any_skip_relocation, monterey:       "fdbd0f7977ae59674f14a6a427cd3bb35b3678034ae0ea687ddf06d2cc49f58d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdbd0f7977ae59674f14a6a427cd3bb35b3678034ae0ea687ddf06d2cc49f58d"
    sha256 cellar: :any_skip_relocation, catalina:       "fdbd0f7977ae59674f14a6a427cd3bb35b3678034ae0ea687ddf06d2cc49f58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5b8e53e095c31190d725d5b1bfc8292d6f73da31da893bd257e6fc71747d45"
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
