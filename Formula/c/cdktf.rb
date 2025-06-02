class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.12.tgz"
  sha256 "90bb30b7eae861d2a7ab21d1fe4ddbf71c8f74e7b2c31052c9b9265ff69d4c6e"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256                               arm64_sequoia: "f3a5571c228c0afe23c7823f29a91085faf6feb8355a54acacf42674f66cfa28"
    sha256                               arm64_sonoma:  "b8d8e69d7a3657a8706747664b19a1753b1d1c516edfa5b5f509208eacb64426"
    sha256                               arm64_ventura: "80736d8e4441e675140caf8e90457ef084a28a0fc55a89230ba89bb1419abd1c"
    sha256                               sonoma:        "fe84c384fef7fe0fccdce3eaf4ac021c08a735a0ace56a558c134cfdb46a056f"
    sha256                               ventura:       "5db5bbf4b1592846f17d5557752f123121fd9b6d2e5308a0f8442ec7801e19dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5e6e9ed6f9ab6fdec3758e977d27f150776d56d8cf30c05fe1903277df13e4"
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
