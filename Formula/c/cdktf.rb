require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.18.2.tgz"
  sha256 "c100edc304d4de05115f110e0f9ff9d0d419ab5aa04cc8ee41beb4056b6f2957"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "6f34f490d244d030099984995cbaf102fb8bf04f605c873f1054e3b7807e24f4"
    sha256                               arm64_ventura:  "8fb57fe56372e65c9ea768117cb5e2faf29f198614e4c17a3867c9ccc64184af"
    sha256                               arm64_monterey: "da374944146cf3acbfe80f064c1515bb76ad1be8839f056ab8e7220587fb706a"
    sha256                               sonoma:         "87d9104515aee66085577aca2241e644d5166e014914272ba8d5aa847a63ac29"
    sha256                               ventura:        "b35a066be444fa337b95fe1c5713be07b22424a3af979ae5b0d8d68e555561dc"
    sha256                               monterey:       "5f11607a85609845b36c0b807c38dfd872e7d375ee5d77dffa14f6fa1b1c2443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fab08fe4707166d75f0644b7b597bd85274998805db9c07f7952d364d4b4825"
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
