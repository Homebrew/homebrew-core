class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.14.0.tgz"
  sha256 "ea5e8f17fbe2ab50455bfedc2db4e490acc6dfbea81861a8d6ca453bc7e210b6"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4631080b5205797791a9ade9f96824d88da1f91d9a78f00cb7462711145f1775"
    sha256 cellar: :any, arm64_tahoe:       "4631080b5205797791a9ade9f96824d88da1f91d9a78f00cb7462711145f1775"
    sha256 cellar: :any, arm64_sequoia:     "4631080b5205797791a9ade9f96824d88da1f91d9a78f00cb7462711145f1775"
    sha256 cellar: :any, arm64_linux:       "b4521e91ce2827977ffa39a09a0bd800f0e4f752933e89a59c17a2c5112273d3"
    sha256 cellar: :any, x86_64_linux:      "b461156bcdd36e2eee0b6b7a48eded0d3434087564fb17f8afb9375a7fc3d6a5"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
