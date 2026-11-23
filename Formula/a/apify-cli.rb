class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.14.0.tgz"
  sha256 "ea5e8f17fbe2ab50455bfedc2db4e490acc6dfbea81861a8d6ca453bc7e210b6"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "a2c68f91d739ece05711ff8ced4e17f25e27a91a02147d9f19c1ad68ff4bc816"
    sha256 cellar: :any, arm64_golden_gate: "a7c8c48bc7b15616e4472d1fe098f8c9f0b37e4614ae1a9c21f76866cc27130f"
    sha256 cellar: :any, arm64_tahoe:       "a7c8c48bc7b15616e4472d1fe098f8c9f0b37e4614ae1a9c21f76866cc27130f"
    sha256 cellar: :any, arm64_sequoia:     "a7c8c48bc7b15616e4472d1fe098f8c9f0b37e4614ae1a9c21f76866cc27130f"
    sha256 cellar: :any, arm64_linux:       "4191f5dc00eaadcb8986114c8b167e43185c33cb7ea57e902650344a33d50d08"
    sha256 cellar: :any, x86_64_linux:      "3220632353d500f44321aed4ad3efbbe530de543de0637c69a18c17aad125371"
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
