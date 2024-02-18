require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.3.tgz"
  sha256 "6566f48ae234d2e5f976da36390b299fd9c64d51c04d71990a38cd72ea178e2a"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "328ea8d6823569461b751c238ea3ef1c2246d1e23949be9e960b09dc1c41b0a5"
    sha256                               arm64_ventura:  "2d2a5906a0078f23352b05f2f4be1ce3bda00c83e6e1b109d7825eb69105ac2b"
    sha256                               arm64_monterey: "95d007d86bbf804a88fa506ff4ce79deb35e78ddf736319eb3fdd041b14e2f6f"
    sha256                               sonoma:         "d6765fd5da735e24e4bc2b0ff4241ca4fd8cad6f0dff61b78bf2a6c98645eb2e"
    sha256                               ventura:        "d08d74969c5a878e36de21b1401c0bf4a06c72f081e26d0624f2ca249086e25c"
    sha256                               monterey:       "f5f9744e6041442540612e58c2144d34e386c810f13d64bf02b0eef331638faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254e44cf09aa91a34632919bbbaddfd6df5a1d59dae83a83af12e86c9b8fa914"
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
