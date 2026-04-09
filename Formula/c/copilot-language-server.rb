class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.465.0.tgz"
  sha256 "1478b9868fb5acd97c45fd348197b7fc39a56874fa2f3c78507b99e8b2de1276"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5140f66e078f164469fde2d9139bb89d00f5efb7d33d6ad5e398420d721dd54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089b3d5c70c08111ee54033d21ab599e1f2a487faa7b4158452f733061684530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269a5806fb17c57998d892ed3922d8a558ae9addbe53f080638ac8230a1c1a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22875f043e7f2b74cf1fc2962afcdb77d3513a296ae4589b48d80f7c4e130f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c549dc84d3264ec361a305acbd06c945c30db9b50390e6518d61a8d1e7384966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebdd354a14a5d1acd43685a4c679230c2b8c72b0d3bdba9e86e53bd858996c9c"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    pkg = libexec/"lib/node_modules/@github/copilot-language-server"

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    # Prune bundled native artifacts for non-host platforms/architectures.
    rm_r(pkg/"dist/bin")
    pkg.glob("dist/compiled/*").each do |os_dir|
      if os_dir.basename.to_s != os
        rm_r os_dir
        next
      end

      os_dir.children.each do |arch_dir|
        rm_r arch_dir if arch_dir.basename.to_s != arch
      end
    end

    if OS.mac?
      pkg.glob("dist/compiled/darwin/*/kerberos.node").each do |file|
        deuniversalize_machos file
      end
    end
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/copilot-language-server --version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": null,
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"copilot-language-server", "--stdio") do |stdin, stdout, _stderr, wait_thr|
      stdin.write "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
      stdin.close_write

      header = stdout.readline
      assert_match(/^Content-Length: \d+/i, header)

      Process.kill("TERM", wait_thr.pid)
    end
  end
end
