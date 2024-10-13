class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.8.tgz"
  sha256 "69e4fe68d4c08bef7702f711143129ba8c58f71ef768f380dafc1981987f55e1"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "29f9252c836e8e13e4ea97f2249b13ccb1533fc1d7424b74896bc0a68ea56783"
    sha256                               arm64_sonoma:  "9a952f8e2eb5a172087916efef210c28df9e99677e0e9315d472cd3c23a80672"
    sha256                               arm64_ventura: "48c6a39648dcfa2bf9970625adef03a2c13c5b86753b39428a1729421c9d0ac7"
    sha256                               sonoma:        "ee958ef4377d9cb4a8426cd3ef63f0f10c48af27619ad13784fb9132374bccf1"
    sha256                               ventura:       "605b00c5de6da561ef2272a535d84dd4879d741880e7db54238a1b7c51f1d10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac4a9ad9c8e608bae4efd4c65fe35ce6635c511e2843110ca5adf47a8e7cce8"
  end

  deprecate! date: "2024-03-13", because: "uses soon-to-be deprecated terraform"

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cdktf-cli/node_modules"
    node_pty_prebuilds = node_modules/"@cdktf/node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    touch "unwanted-file"
    output = shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
    assert_match "ERROR: Cannot initialize a project in a non-empty directory", output
  end
end
