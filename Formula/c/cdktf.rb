require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.18.0.tgz"
  sha256 "fad6a70342e4f6855cf704849518b78ad9d68a6bec4ba933bf57d2297233d8ae"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "2630edb0e543fdfe9ef02f8734ff40ef4dd61bd92e0861c5ed7e698e08f2a696"
    sha256                               arm64_monterey: "ae2422e2e54aa2fdd2f4ea3729b73bafc1a1f5cb46f9b90b29616f1a18113754"
    sha256                               arm64_big_sur:  "07dffeaccc3191ce338ab9e04ffac32df7a25cb3d5806f580297196528a44486"
    sha256                               ventura:        "58af90dc88edd3eaecd4e0adb6052bb8ccb0c4ff57739b81dc4253ad387b9d82"
    sha256                               monterey:       "e130e4f3c52efb16c2e71d66a689722b6cee8f8891b5773cc6aa8011c1933316"
    sha256                               big_sur:        "299cd6a93e45399e4d04b19235411d030897415eef4d723d59a4356c7e77ffbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76d9f6c9ec099dbd5c4dc62e5e9833a318aaa75ba03a86ee7229b09193a91f6"
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
