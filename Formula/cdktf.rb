require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.17.2.tgz"
  sha256 "275a5a84f6cc4c004936789fcf51a3317d761cb7fb109dfc5e4331168ca3c0a9"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "86ce04a17c591a5e71ca2786b8488f5bd10718c0d5b28b6c3d9ac898e38b6133"
    sha256                               arm64_monterey: "75e19f38b05ad4e0f4538b446f966374e21bdef4cf35514e2ae081914c161585"
    sha256                               arm64_big_sur:  "a6f961b91de881a86ec89c1855c87c416a61eb7bd813a4ae3a82cd2124417ec6"
    sha256                               ventura:        "f9b923646f4af45fac6293814d0f074c1c94550833a532ce41f0065eaa278698"
    sha256                               monterey:       "4364356965961c116350acac5331dd16a399b36bd3a4872db509e0b21ea73eb6"
    sha256                               big_sur:        "820f6a17cfb21ff49acbf4bb75e9c065852396a8352d04192c4961f30b152141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75064f7a131c48cf3ee5716aaa9fdb8dcc98e4fdcc344e9ae0189a8bc04b3c6"
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
