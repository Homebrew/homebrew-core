require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.1.tgz"
  sha256 "8060ae79be2a2bb0f8615b7559c571002640c4b033994cfd8babb8859a41a69a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6952bbfd69b1c73229752cb4e2d6d70946f8af2b8c9564a345d957fe6603b70a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6952bbfd69b1c73229752cb4e2d6d70946f8af2b8c9564a345d957fe6603b70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6952bbfd69b1c73229752cb4e2d6d70946f8af2b8c9564a345d957fe6603b70a"
    sha256 cellar: :any_skip_relocation, ventura:        "3e79e9fcbb4e60434d308f34899d88e931f8d26148cd93b26162ab9bab2cacc8"
    sha256 cellar: :any_skip_relocation, monterey:       "3e79e9fcbb4e60434d308f34899d88e931f8d26148cd93b26162ab9bab2cacc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e79e9fcbb4e60434d308f34899d88e931f8d26148cd93b26162ab9bab2cacc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d064535e9cde0c85594c89a6359933bd8d59f1661c68441fd71f9cf14e7f5280"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cdktf-cli/node_modules"
    node_pty_prebuilds = node_modules/"@cdktf/node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
