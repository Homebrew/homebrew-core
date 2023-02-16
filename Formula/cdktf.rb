require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.5.tgz"
  sha256 "ff6fd35c801d3944253c5c97eefcb996859271ea3a70df81fdb6bfdf2b2a23b1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0879bb939059fd8d3979e8a5832deddd2b2371939b9407d1b07db5cc63ef40c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c756511aa3190d4deb035ad065fd53125016380b49dc96342e2633093f4a62ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16248b50dc32af2dfa4b1a8f8051c5406adbbcf962cff31df7d78a797fa949ad"
    sha256 cellar: :any_skip_relocation, ventura:        "2904aac6d2aabab5380aca6ae771cd10bf64a5103423f7bbdd7eb9b647857553"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e3852be434282f67db1a67cbe859bdbc1e40a20f6ef25f82b888dd607ab553"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e03e0a4f97c59131e874e893042b4832203a364a514e7dd897b23ea85640e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2fc6d99ead739f9672e2d5e63ba0862ca9f4d55b7760df017d5ac2cf44936f8"
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
