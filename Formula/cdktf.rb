require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.12.0.tgz"
  sha256 "244a72b7ed5d74dd9d038f433c0d06f8bde72dd5d807d3622cffb88dd6908a71"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69685c39f6b63077fbb95e25d4a36bd0e200e7ea8be7a9b2314f17a7fe5885fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69685c39f6b63077fbb95e25d4a36bd0e200e7ea8be7a9b2314f17a7fe5885fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e1bcd630b0c6d0177406913eddb70d8542ee9eb70ea0ba93fa7f3e36803e0a5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1bcd630b0c6d0177406913eddb70d8542ee9eb70ea0ba93fa7f3e36803e0a5c"
    sha256 cellar: :any_skip_relocation, catalina:       "e1bcd630b0c6d0177406913eddb70d8542ee9eb70ea0ba93fa7f3e36803e0a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69685c39f6b63077fbb95e25d4a36bd0e200e7ea8be7a9b2314f17a7fe5885fe"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # completion script currently requires --help run without error https://github.com/hashicorp/terraform-cdk/issues/1905
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, libexec/"bin/cdktf", "completion", "--help")
    (bash_completion/"cdktf").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, libexec/"bin/cdktf", "completion", "--help")
    (zsh_completion/"_cdktf").write output
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
