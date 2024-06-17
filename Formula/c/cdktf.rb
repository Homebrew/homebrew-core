require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.4.tgz"
  sha256 "a2e5c935958828154ce736888a4259a5e782130a6cc628baab91050686c2fe42"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "c6c3fd92fa6fb45295ee9753873e04d226ddd633dcb639eb89d18ebd4a375caf"
    sha256                               arm64_ventura:  "a8292a25b7d45df4ba791f40872165dee2785efe0d753a1d9888e742fab9250c"
    sha256                               arm64_monterey: "0e511a319c8ee3169b04f1305945c5307aee19bbad9f2890cc33fa35de9cfd5c"
    sha256                               sonoma:         "ab6caaa54e6917839f4ae365d69981097f2e2037d2e8169538a4220d9aefb29d"
    sha256                               ventura:        "a492ddf71a3f462cc5ad66e991c28b0135073b37c144cd679ae4e1f45cc3f87a"
    sha256                               monterey:       "d303976fa24b5cd3ff52542fd6e94ff11c0515398c2e9b285c9b67f754883848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3672caff49c3eedaa4014e4da69d7bc198d68344000473d45305716352e4fc00"
  end

  deprecate! date: "2024-03-13", because: "uses soon-to-be deprecated terraform"

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
