class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.11.0.tgz"
  sha256 "bdb2adfc374aeb876e0d183c6c4fb4975691b795a6e28b5758abf2277d15bb70"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2b0c5e1342629cf8aabc481feaa2baf274bef72256f08a63b01bc28f6d8b0120"
    sha256 cellar: :any, arm64_tahoe:       "2b0c5e1342629cf8aabc481feaa2baf274bef72256f08a63b01bc28f6d8b0120"
    sha256 cellar: :any, arm64_sequoia:     "2b0c5e1342629cf8aabc481feaa2baf274bef72256f08a63b01bc28f6d8b0120"
    sha256 cellar: :any, arm64_linux:       "69667d6d9a0b96803e61bf10b40068a9abd5c6447fe9c2171336f34d2da8b6bc"
    sha256 cellar: :any, x86_64_linux:      "ab29d89eeb0ab2613102d86fde2fb87c519ea04e00ec2b2b914c3e572b5422aa"
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
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
