require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.16.3.tgz"
  sha256 "c9140611a0efb25e471d894c52e506240f2bd524d54b6dbf3f8c916b8714bf94"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5be1e6c3f26ebea932e60abdf03e90b135ccf6f7513d60a47d77a9b048e7b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5be1e6c3f26ebea932e60abdf03e90b135ccf6f7513d60a47d77a9b048e7b52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ffb718953c4b696e9cdc0007908146062e3ece97f7a57b0b09dbb0053097dd2"
    sha256 cellar: :any_skip_relocation, ventura:        "0cbb2dc253b89bc17d6b34d58041d6a53d34758f520c6244723ecf12662e5088"
    sha256 cellar: :any_skip_relocation, monterey:       "0cbb2dc253b89bc17d6b34d58041d6a53d34758f520c6244723ecf12662e5088"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbb2dc253b89bc17d6b34d58041d6a53d34758f520c6244723ecf12662e5088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5287e043f8b58c5f9d02d5b23c37dfe03fb332e02f1f2cd76953aad0156b5f9b"
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
