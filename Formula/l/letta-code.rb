class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.11.tgz"
  sha256 "263da91c0b84756be988080e282f233ef72a7c6fa7b7ac42c64a111f70232022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cdb06816fe351b6c547547be7ffea60be913ea93a56cee05666e60cbb15a468"
    sha256 cellar: :any,                 arm64_sequoia: "e1806f29c65a689ce7353b6afc184586fd80b65bab2cf6d5d877a08d06cecb04"
    sha256 cellar: :any,                 arm64_sonoma:  "e1806f29c65a689ce7353b6afc184586fd80b65bab2cf6d5d877a08d06cecb04"
    sha256 cellar: :any,                 sonoma:        "2fa37f8ef0981086659938201863952bff73e27a0ef24437be6f7e5a261a3c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76141c22f861b2df0cf8397804afba9fe581ba29fa1f55d454d26752ac8129e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbf4ea89b4a2fe094a377c385befae088014293cae3b29cffa3e0b01aee0cc0"
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
