require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.4.tgz"
  sha256 "88e67476d16503ad6bb50ff1dbc8344b41d52a2989c99c81e6af9a9055c3383f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb86fd051dab82c69fd96a6b46b2872690722960443e2c8ab43955ff28d1e564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb86fd051dab82c69fd96a6b46b2872690722960443e2c8ab43955ff28d1e564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb86fd051dab82c69fd96a6b46b2872690722960443e2c8ab43955ff28d1e564"
    sha256 cellar: :any_skip_relocation, ventura:        "3ba4a696b7216a2e65447ac1db106d7abba486c20340d7de451faedfdd880815"
    sha256 cellar: :any_skip_relocation, monterey:       "3ba4a696b7216a2e65447ac1db106d7abba486c20340d7de451faedfdd880815"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ba4a696b7216a2e65447ac1db106d7abba486c20340d7de451faedfdd880815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526da9d90e94b17b87be8e5b766773028badc26c85f84cee9bab77d4b44a4197"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

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
