class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.21.0.tgz"
  sha256 "5885318063a55b44f87c917fe5806379937f7aecad5fe766bc898a1519de56b6"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "f578d63eb4a956b48e9c9c16aaab47f11f03fdd7116d0d725a6e952d280e7ccd"
    sha256                               arm64_sequoia: "7d373a388353fd948c21d43f7bb49483bdacc5f43a8c7e0a00a7bc456bcabe07"
    sha256                               arm64_sonoma:  "3af0f208b1aa7e65a16754356dac5b7ce395313a27bcf9c26e35908f025e529e"
    sha256                               sonoma:        "4fe3dd2844bd6a15198b8796c15d6d7b6f4b74a56de6815eeba5d7ba82444459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce0176ec3db721cdab92513cf302e9ba61985c010e79f5e0da270bd6fe32056e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d87963c5ad6b246c64cd56cbe1cd35868e4d4758aa7c6bbf560c12c50cfe0b1"
  end

  depends_on "opentofu" => :test
  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    (bin/"cdktf").write_env_script libexec/"bin/cdktf", PATH: "#{Formula["node@24"].opt_bin}:${PATH}"

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cdktf-cli/node_modules"
    node_pty_prebuilds = node_modules/"@cdktf/node-pty-prebuilt-multiarch/prebuilds"
    node_pty_prebuilds.glob("linux-{x64,arm64}/node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    touch "unwanted-file"
    output = shell_output("#{bin}/cdktf init --template=python 2>&1", 1)
    assert_match "ERROR: Cannot initialize a project in a non-empty directory", output
  end
end
