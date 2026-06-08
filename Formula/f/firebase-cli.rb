class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.19.1.tgz"
  sha256 "361f8793e5d7bfb6407c79d239fb97d35c2ebf3dace46125624d9f1cea620008"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f6f72d53dbe8155e93569d45023defab45c47b52d94de40f5da42eda7817a19"
    sha256 cellar: :any, arm64_sequoia: "df9ce396012097316b452b897041573f16efa7211cf4211c434a36d87589c25d"
    sha256 cellar: :any, arm64_sonoma:  "df9ce396012097316b452b897041573f16efa7211cf4211c434a36d87589c25d"
    sha256 cellar: :any, sonoma:        "7a71531d2b9c32f0c1dbdc0eaeb852bf864cb67f6ea62664edf6322e873e7210"
    sha256 cellar: :any, arm64_linux:   "6fda949bedfd5fe79f7a46fcbb1c001893b4f5acce4a18167b0b8d6cf7b25300"
    sha256 cellar: :any, x86_64_linux:  "f9ae4c6dcfe72496fcf0f1da980cb8c7cf01c2e8e832bd77755be8f1c07b2b68"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
