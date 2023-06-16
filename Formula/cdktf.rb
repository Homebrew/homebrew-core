require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.17.0.tgz"
  sha256 "6c061873661a7da3727dceb3403895ddfca897deb855b189b7be363d10d0d691"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e30629e7ea16a86eedbdec8c19c5a701f27b8de4e2efb7719368a97c02fce98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e30629e7ea16a86eedbdec8c19c5a701f27b8de4e2efb7719368a97c02fce98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e30629e7ea16a86eedbdec8c19c5a701f27b8de4e2efb7719368a97c02fce98"
    sha256 cellar: :any_skip_relocation, ventura:        "a31e509e72df32b186275337739b3140ee4be4866a23a8bd74936bded6cf3d98"
    sha256 cellar: :any_skip_relocation, monterey:       "a31e509e72df32b186275337739b3140ee4be4866a23a8bd74936bded6cf3d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31e509e72df32b186275337739b3140ee4be4866a23a8bd74936bded6cf3d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd75d95e3f98e05f154fe0f0429f8bcf228b0edd20fae50ff0ac5f282f03a39b"
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
