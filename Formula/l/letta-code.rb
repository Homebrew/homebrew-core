class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.9.tgz"
  sha256 "2de19dfb2a918ba0085267b97c7859aea5bc41acaa0074444a07c4e488941de6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a517c7e225491a42bb3f2de51d6d111af5258cc376162a6f2187172d103a719b"
    sha256 cellar: :any,                 arm64_sequoia: "7f7e79d049a7f8ae7433d867595369b922c4cba9e1d02caaadec77bff3ffeaa7"
    sha256 cellar: :any,                 arm64_sonoma:  "7f7e79d049a7f8ae7433d867595369b922c4cba9e1d02caaadec77bff3ffeaa7"
    sha256 cellar: :any,                 sonoma:        "42d14351f913d19056083e55ccad87399ff486fc05d52026cc2d09f60396ed91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c19270ab69df399e55c5289840208995c1ca9dea8b9fa4009005abe170cd4b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bffb0332536d9fe4bc7bcd637bd81a42e06505e83af4a6d563f3849b02047610"
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
