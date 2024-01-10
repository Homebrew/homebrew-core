require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.0.tgz"
  sha256 "bbb75fcc8bde5d60dcfe7959154a870b34381bb99957a2b74d3207bdbf3214eb"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "7288629f198ab93bebdb4b8b8d4ec10d44f31ac45c8c34d88f52cae78186fe5c"
    sha256                               arm64_ventura:  "1e6c05ca6d42744e7e2343318172fe34ab81a03fbfb18261c24e0e7377c5a905"
    sha256                               arm64_monterey: "0c7d6531f4384e1a48fdb351b28a253cd2a671699f5488f9700e48fe28928458"
    sha256                               sonoma:         "782506b5abe126624220c7118bd251bc3c680d9d5a9d05430643ec790b622382"
    sha256                               ventura:        "ccb87d74e05ba0bbe95a8bb7aa40e7a93fadd40c9c9ce1be726c85767bf05224"
    sha256                               monterey:       "3781fad9088c3d02977afcdcc2f1a9df5c033dc28d694045840678d6dfb6b594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aff39bdcc45bc7c7a5ec6b945f609023b28231f8c9b79c06865df4581dc5a5a"
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
