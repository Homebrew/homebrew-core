require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.12.2.tgz"
  sha256 "9b2e97c530a32d5523f95220b111d8aa44c93926d94595b8feae0d8f75883d83"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a53290778e778d23b0db56c2a7f3c9b09ec763541c7057a6f7d594781142624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a53290778e778d23b0db56c2a7f3c9b09ec763541c7057a6f7d594781142624"
    sha256 cellar: :any_skip_relocation, monterey:       "11a070abf3a2fb93216accb11499a0ac95cd3aded05901de0ee4801c8276b20c"
    sha256 cellar: :any_skip_relocation, big_sur:        "11a070abf3a2fb93216accb11499a0ac95cd3aded05901de0ee4801c8276b20c"
    sha256 cellar: :any_skip_relocation, catalina:       "11a070abf3a2fb93216accb11499a0ac95cd3aded05901de0ee4801c8276b20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a53290778e778d23b0db56c2a7f3c9b09ec763541c7057a6f7d594781142624"
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
