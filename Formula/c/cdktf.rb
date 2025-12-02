class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.21.0.tgz"
  sha256 "5885318063a55b44f87c917fe5806379937f7aecad5fe766bc898a1519de56b6"
  license "MPL-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "0e40207364977f0eb648b11eae2b766f395a8b6dbaf680eecd2cb801b84ef05e"
    sha256                               arm64_sequoia: "d2628c7283e20253e054eaeb7fafda0ccfdea6ccebe1f669ba298c856df85e7a"
    sha256                               arm64_sonoma:  "949a4c44c8a74fc2a603272681a0c28e74215b7a7a231f7872b62155c5992bd2"
    sha256                               sonoma:        "bfb78f5f4bc567f55479f27a3311345e03e6243e2d4e28b5e534d9835e1de15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f49385492136b6ebfb77a1b6997404bdacfa0e51f19a88bd594728b7c98e556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76169751063d6f5b6a692119e83dcc4038d92456e9870877947dd3981277d3f6"
  end

  depends_on "opentofu" => :test
  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
