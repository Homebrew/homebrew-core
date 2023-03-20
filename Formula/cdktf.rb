require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.15.5.tgz"
  sha256 "ff6fd35c801d3944253c5c97eefcb996859271ea3a70df81fdb6bfdf2b2a23b1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95fcc41d2c4cacef93d0bd1c3ff87732077224104a1a8eb314130d342c73b0fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95fcc41d2c4cacef93d0bd1c3ff87732077224104a1a8eb314130d342c73b0fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95fcc41d2c4cacef93d0bd1c3ff87732077224104a1a8eb314130d342c73b0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "12d21f06642cc30c25e17d766f369228c3b67bd5d24b2c04adaa66a448e4d6c6"
    sha256 cellar: :any_skip_relocation, monterey:       "12d21f06642cc30c25e17d766f369228c3b67bd5d24b2c04adaa66a448e4d6c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "12d21f06642cc30c25e17d766f369228c3b67bd5d24b2c04adaa66a448e4d6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d015df7cc203b6a2b8e8a0db6872bbde3f47bb0d8365990fac90e51bb7004f7a"
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
