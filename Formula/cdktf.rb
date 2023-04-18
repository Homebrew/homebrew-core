require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.16.0.tgz"
  sha256 "cdb699c2ca5c133504896921ad587338b9fc42529f8af2add2733a38170e2b63"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db068b829fab530dcac7452f57e83ac9d957acf282e497f0d40e7651b3b3d6ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db068b829fab530dcac7452f57e83ac9d957acf282e497f0d40e7651b3b3d6ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db068b829fab530dcac7452f57e83ac9d957acf282e497f0d40e7651b3b3d6ae"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8a725643bb3593f477ed0bc87a86407653545ddb41473c7e20e10e6e4ff3cc"
    sha256 cellar: :any_skip_relocation, monterey:       "ff8a725643bb3593f477ed0bc87a86407653545ddb41473c7e20e10e6e4ff3cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff8a725643bb3593f477ed0bc87a86407653545ddb41473c7e20e10e6e4ff3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67900b2396789c0896dd83d226ade948c912f30ca6c583b7f62a30a6d9d09e66"
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
