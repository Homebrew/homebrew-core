class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.6.tgz"
  sha256 "0d97ade92c60535c42513941dfc7531ae98052b69b506020a26009a33c630b20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73ecc9274ef41d505558f1323974a9c7393a581c5df0e74f9837b0542d42bb53"
    sha256 cellar: :any,                 arm64_sequoia: "3037c5bebad0a0846eb5b8f3f31a4bae3cecf1474ddacdb90d93326618cd6aec"
    sha256 cellar: :any,                 arm64_sonoma:  "3037c5bebad0a0846eb5b8f3f31a4bae3cecf1474ddacdb90d93326618cd6aec"
    sha256 cellar: :any,                 sonoma:        "0f8a71ad31fc45682fd9f0b916847a58bd7be2b7d30c52054354adef9e0e272d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69ec60120db63ce8e3902edf77be16185a970373cdbff56005ccf2fccf0b91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dca0a30880c9117069a0aa7bf1eba00735ee3de269dff4da1d9ca8b449081e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
