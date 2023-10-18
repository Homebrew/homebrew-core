require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.19.0.tgz"
  sha256 "1e8cf857b5ef4ef2b737e8366a51a923013d231c38ff301d0a43c14f293c1b4d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "958644c1bb520bb5317ed1a36ee7c4433c52c39b33e8876488c9ef8316e43c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "958644c1bb520bb5317ed1a36ee7c4433c52c39b33e8876488c9ef8316e43c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "958644c1bb520bb5317ed1a36ee7c4433c52c39b33e8876488c9ef8316e43c73"
    sha256 cellar: :any_skip_relocation, sonoma:         "3708004d66e6b6bed1e15635a0bbc6ba011ed2f4238992851c7d99320854865c"
    sha256 cellar: :any_skip_relocation, ventura:        "3708004d66e6b6bed1e15635a0bbc6ba011ed2f4238992851c7d99320854865c"
    sha256 cellar: :any_skip_relocation, monterey:       "3708004d66e6b6bed1e15635a0bbc6ba011ed2f4238992851c7d99320854865c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3091a78e5fd8c77097701c4f8b7e2c0433c3e8ac2b32527997f34360f6a9d37"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
