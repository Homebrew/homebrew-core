class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.7.tgz"
  sha256 "09316276bce819250738538c0933f8ba125fa7c8cf6975ed272777031dc3513c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a390934366643a547223a558030e61d17af55ea616dae208a96f08c0721cdb25"
    sha256 cellar: :any,                 arm64_sequoia: "9b92507020f2fb4849f572ded1e8f1107a3c48b80ec23557274065fd6ae8f2a3"
    sha256 cellar: :any,                 arm64_sonoma:  "9b92507020f2fb4849f572ded1e8f1107a3c48b80ec23557274065fd6ae8f2a3"
    sha256 cellar: :any,                 sonoma:        "0e289613fe4bae1b6cabb64527ee0e9346be6c12c8768a826e948f410af26a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e28d49526a4662171c6c39ded5e5adc8006191142cb17aab825c0c1e254dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711b006ff66a7f9ff2691e03c0f2cb34e2ac07a8250ac5c532492ed7b5934334"
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
