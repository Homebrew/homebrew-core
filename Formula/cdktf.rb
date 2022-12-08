require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.14.3.tgz"
  sha256 "eea5d55d6bc6f626c84900d34573928672c708d98b0dbabfc39b54d654de1cc5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fc793cef4e9c548a1eba2f2d49029b8f5d8fbfce36da57d24f5c6ad7a842bc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fc793cef4e9c548a1eba2f2d49029b8f5d8fbfce36da57d24f5c6ad7a842bc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fc793cef4e9c548a1eba2f2d49029b8f5d8fbfce36da57d24f5c6ad7a842bc6"
    sha256 cellar: :any_skip_relocation, ventura:        "041b6202efae5f2dff1462e90787772a60a515b9a320d7f95ba207287e4cfcfd"
    sha256 cellar: :any_skip_relocation, monterey:       "041b6202efae5f2dff1462e90787772a60a515b9a320d7f95ba207287e4cfcfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "041b6202efae5f2dff1462e90787772a60a515b9a320d7f95ba207287e4cfcfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc793cef4e9c548a1eba2f2d49029b8f5d8fbfce36da57d24f5c6ad7a842bc6"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
