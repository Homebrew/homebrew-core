class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.7.tgz"
  sha256 "dc35cd7fb413c411391ef175f443af7969a5c2cfdb682d0be09be42ac72d6ac2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "341bc9b8f11fa7439efe30873b06628c89568a8e1550e743a2e274e06a6f0609"
    sha256 cellar: :any, arm64_sequoia: "341bc9b8f11fa7439efe30873b06628c89568a8e1550e743a2e274e06a6f0609"
    sha256 cellar: :any, arm64_sonoma:  "341bc9b8f11fa7439efe30873b06628c89568a8e1550e743a2e274e06a6f0609"
    sha256 cellar: :any, sonoma:        "fdc654ff42d17436aba4b02e7cd4444c14c0322750d1270a39749f86427866f0"
    sha256 cellar: :any, arm64_linux:   "faf7046e78ff022342c9b8a027aaca5db68468d2ef833b4c8a7ea9966bceb551"
    sha256 cellar: :any, x86_64_linux:  "7504dd009f1dd42f09e01249e922dff0af12a8562c495a956e642665f9eb9d64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
