class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.1.2.tgz"
  sha256 "fb5892908471f1cd63e970817e4df1b821a54ffc45759516201c26ce8b4fd24c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2b45deb6d78341b196a8ee4085d85c33f47e18adde859ba17d142584ff8b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07298359e6b33af582e3d464db5a23a01928a25b66215ee25ece19c85019a1bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde82fd314bdeea7110005ddf864668948b1ce9adb93645053b84483c8cfe3b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8554790778f55fff91b2297d772d337da2f6f0e7fc66f6870401602b85164fd9"
    sha256 cellar: :any,                 arm64_linux:   "33048793ab006d7ca43f12dae3ac306380d50392ffc2c4cbff8c23c243f2e451"
    sha256 cellar: :any,                 x86_64_linux:  "ea5f8f4915a88f34b11f2c286eaa6267d0a23d0e1354dbb42450a4ee110b9442"
  end

  #  disable linux bottle for now, since it is not working due to the following error:
  #  Unwanted system libraries:
  #    /lib/aarch64-linux-gnu/libtinfo.so.6
  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _e, w|
      stdin.write json
      sleep 3
      output = stdout.readline
      assert_match("\"protocolVersion\":1", output)
      assert_match("\"agentInfo\":{\"name\":\"@agentclientprotocol/codex-acp\"", output)
      Process.kill("KILL", w.pid)
    end
  end
end
