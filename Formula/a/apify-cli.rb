class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.7.0.tgz"
  sha256 "4f240ba786b9f59d59d568652e85d0042610999a507fd9aba4fbfe5e6b9391e0"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3dcad391e0b1cfe3f651d2186308a350cf7ad1ba444d5dd392a7e3412a8712a"
    sha256 cellar: :any, arm64_sequoia: "d367cdba92f2b8f3b3c3634b95c0bca869e11bd28f0a3250234490e34dd5ef72"
    sha256 cellar: :any, arm64_sonoma:  "d367cdba92f2b8f3b3c3634b95c0bca869e11bd28f0a3250234490e34dd5ef72"
    sha256 cellar: :any, sonoma:        "bdd9ec3de9ddb422643ddfcf8251cb44606901ca101aea845d55c2983293cf3e"
    sha256 cellar: :any, arm64_linux:   "67ba8472e885ba594f8024c8c49df6c873f3716bee6c50f5ef416c85882d1cb9"
    sha256 cellar: :any, x86_64_linux:  "d85fb741992267497436aec23fa0842033846b89daf5dad7c5c5f8482103e35d"
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
