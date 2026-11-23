class ActionsLanguageserver < Formula
  desc "Language server for GitHub Actions YAML files"
  homepage "https://github.com/actions/languageservices/tree/main/languageserver"
  url "https://github.com/actions/languageservices/archive/refs/tags/release-v0.3.62.tar.gz"
  sha256 "b6d469b5af6e87ff55e125b203081ff026204f7f670d03d8c0c7820c40768961"
  license "MIT"

  bottle do
    manifest_sha256 "5efd70420f8adbd4de40eec98febdf1f20033b3c8d6d7f18a4b7d30d71c33f83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17c38f6efee9d21f689bc487ad1e341bbc75d19029d82a96799996e1ff6e4c0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17c38f6efee9d21f689bc487ad1e341bbc75d19029d82a96799996e1ff6e4c0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17c38f6efee9d21f689bc487ad1e341bbc75d19029d82a96799996e1ff6e4c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b454eff5cd25ccaf1e7192a0f40957818f99f4df1872ffcfdfb38fffe2b8acf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b454eff5cd25ccaf1e7192a0f40957818f99f4df1872ffcfdfb38fffe2b8acf3"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "run", "build", "--workspaces"
    libexec.install "languageserver/bin", "languageserver/dist"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    require "open3"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"actions-languageserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
