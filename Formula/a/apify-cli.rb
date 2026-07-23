class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.7.1.tgz"
  sha256 "9ce5d98257aa676f8ac52ddd39a685a579a98755e0f96323378de0f822c3a286"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e0c16bcf0e8b8e23ad4de21c68317757157865a3b0980a1b4e5511d48880953"
    sha256 cellar: :any, arm64_sequoia: "b7aa02b6f692ad7b6d02ef5dee08455bb1fc5611455646e01de61a713d436810"
    sha256 cellar: :any, arm64_sonoma:  "b7aa02b6f692ad7b6d02ef5dee08455bb1fc5611455646e01de61a713d436810"
    sha256 cellar: :any, sonoma:        "188e5362686b672e8890a3db3373acf54a87b9a8b2f7af887f6c803d32fa122d"
    sha256 cellar: :any, arm64_linux:   "2c3f70c96385d61ac8be8e5a4d51dc71d0a81fe2a23cc5ce65a6dcb0b1ab8dbe"
    sha256 cellar: :any, x86_64_linux:  "22e18000aad413a7bb5189e1365f0ee30565552171d0520aa4a6409afa05fb3a"
  end

  depends_on "node"

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
