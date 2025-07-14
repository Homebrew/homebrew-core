class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.21.0.tgz"
  sha256 "5885318063a55b44f87c917fe5806379937f7aecad5fe766bc898a1519de56b6"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "f5e3dddef4a75c7db589bc1d1052e974c1b2fc209a2bba4efd379da5227db4f8"
    sha256                               arm64_sonoma:  "4febb127a3888f57b9c2992f4c5894028154ffb4c938cd9dad6cf9bf222de47f"
    sha256                               arm64_ventura: "07de2f8ab86258e1413e355a5ace5ce1bed2f637031861b013b1ccb04ba044b6"
    sha256                               sonoma:        "4307f3bd75cc1b46b281df158e32c299bfa0051bbe57fe4139a427e229524c45"
    sha256                               ventura:       "eda9a5cd48c776d1a99ed9afbca4706178f793166dd1aa062233eb728d2d0fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361f8a42a54fda4f627e1b9fa593f68a68f557e963a8bb6f82bd0a6998fae7cc"
  end

  depends_on "opentofu" => :test
  depends_on "node"

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
    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    touch "unwanted-file"
    output = shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
    assert_match "ERROR: Cannot initialize a project in a non-empty directory", output
  end
end
