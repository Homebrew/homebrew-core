class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.6.1.tgz"
  sha256 "e2d248ff87a203aa86942921002b46a301f4b9d661bab2bfcb0a8e9fe3c4769e"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bda82e54e016d0a1b32af735dedb8053b6a29e1c7d35b272dea4793a6a8a6260"
    sha256 cellar: :any,                 arm64_sequoia: "9811c347aa4f71a6efb10980b6e4d44e0de7372fd4c4c5410826dba02f12c8bf"
    sha256 cellar: :any,                 arm64_sonoma:  "9811c347aa4f71a6efb10980b6e4d44e0de7372fd4c4c5410826dba02f12c8bf"
    sha256 cellar: :any,                 sonoma:        "13425dc512c7ed91345b23a928814ee68f98b5026a047bbee5e7f20dd5892ac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b6f3fedb3f2a8f524fb9dcd0ae6fc6f56a8ce5bbe0e581ff1d4b614914cdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80fef8d81bf12b26a2a9484ca1c6168cff577eaea6fc0709e3a0068bea122fbf"
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
