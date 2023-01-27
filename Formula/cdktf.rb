require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.2.tgz"
  sha256 "35f4ccf296e69388c2f07fcf839dd1e488d9edb69d226f3d92f058435df94d4a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fae2a3f6b130cd1770d0039423a435ee7f07bdfd8a1c4c3326598b1ecbcb8e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fae2a3f6b130cd1770d0039423a435ee7f07bdfd8a1c4c3326598b1ecbcb8e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fae2a3f6b130cd1770d0039423a435ee7f07bdfd8a1c4c3326598b1ecbcb8e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f8226af549e96e73f2ba7ad23d8bf25f8a5ef657320d69419cc55c8e48c0d751"
    sha256 cellar: :any_skip_relocation, monterey:       "f8226af549e96e73f2ba7ad23d8bf25f8a5ef657320d69419cc55c8e48c0d751"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8226af549e96e73f2ba7ad23d8bf25f8a5ef657320d69419cc55c8e48c0d751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86b04467c788c40d4cca92a5cd9a8f93f3cb61f80374741d7274c9a14ea5f9c"
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
