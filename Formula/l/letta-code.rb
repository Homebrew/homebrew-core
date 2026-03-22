class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.6.tgz"
  sha256 "4c4876826aa2d5731a14a0a35d6750ec944de2daeebebad9a3fba5886cef562d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c8d5c5ee2c32e8934069380e5c4366ba37574eae6c3946639b45ce48cb39857"
    sha256 cellar: :any,                 arm64_sequoia: "7b0139655c9be2226cc210fe9ed0c0eb412a1aa8a0b1d627e9bb1280bf95a67e"
    sha256 cellar: :any,                 arm64_sonoma:  "7b0139655c9be2226cc210fe9ed0c0eb412a1aa8a0b1d627e9bb1280bf95a67e"
    sha256 cellar: :any,                 sonoma:        "860cfd3f9f6efe36a45ee43517f7d52b3f252adc8eebaa92aeced0b9bfccf819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca895c19ba765e440a22c1bb53b65eb6875a85fd8ed62dcdfa505bc53c4ded9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d201ab2b61918c3f8a49a79abfee62817ec13aaa31a1b84aeced335a2ef94e9"
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
