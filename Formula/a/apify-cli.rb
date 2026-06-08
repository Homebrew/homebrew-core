class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.6.2.tgz"
  sha256 "479d96ed3a4eca128b790a8dd7d3bfcca151e776d44ce12161af3a63755dc5fc"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1982d40c55429ac8df65c46accfd94ed7b79789d945a85efc144ecaf62b97118"
    sha256 cellar: :any, arm64_sequoia: "9bebacbfa05e7e92a2fdc09ba6ba2f908379eb9b43e7b6c058116714b0abcf8c"
    sha256 cellar: :any, arm64_sonoma:  "9bebacbfa05e7e92a2fdc09ba6ba2f908379eb9b43e7b6c058116714b0abcf8c"
    sha256 cellar: :any, sonoma:        "c55325395d31b7508543f7afbb190f6b72458055c2c97dbca00398657e08e606"
    sha256 cellar: :any, arm64_linux:   "6b8df8c45b15bf250c9b0e7c607a86683f9f1ddf67c0815783df57f7ecc5059a"
    sha256 cellar: :any, x86_64_linux:  "fb1309da23a6c3ef1b187fc6d2e0214a483b07178f66b4aca76f737b733bc5d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
