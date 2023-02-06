require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.3.tgz"
  sha256 "b174fe485f34a9ffc46f9b9e93bbe3e23cc4ba5f3881d8bb84723ac7ed67e678"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46d9dc1fe133af9e3f942f108e32b32b7bb00609d586fe794a69f38ed6fb3746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d9dc1fe133af9e3f942f108e32b32b7bb00609d586fe794a69f38ed6fb3746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d9dc1fe133af9e3f942f108e32b32b7bb00609d586fe794a69f38ed6fb3746"
    sha256 cellar: :any_skip_relocation, ventura:        "7827561e7a70cdc8742f1d576ae47e2a69cbc0066cbf4d18db0400eb3e4a69b5"
    sha256 cellar: :any_skip_relocation, monterey:       "7827561e7a70cdc8742f1d576ae47e2a69cbc0066cbf4d18db0400eb3e4a69b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7827561e7a70cdc8742f1d576ae47e2a69cbc0066cbf4d18db0400eb3e4a69b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfaaad88c900be5f55fdddfac0313e255d159772924424ebeec3613b8b347384"
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
