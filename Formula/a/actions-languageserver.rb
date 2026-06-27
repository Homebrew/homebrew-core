class ActionsLanguageserver < Formula
  desc "Language server for GitHub Actions YAML files"
  homepage "https://github.com/actions/languageservices/tree/main/languageserver"
  url "https://github.com/actions/languageservices/archive/refs/tags/release-v0.3.58.tar.gz"
  sha256 "83d24888f9b328aaf84a382f1fff718968df4255dca1ec097765131ae993d558"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79cc9b6e4c41112c039af269f4fe1a1378e59a30aaa8059a1b74bf3d953a8361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79cc9b6e4c41112c039af269f4fe1a1378e59a30aaa8059a1b74bf3d953a8361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79cc9b6e4c41112c039af269f4fe1a1378e59a30aaa8059a1b74bf3d953a8361"
    sha256 cellar: :any_skip_relocation, sonoma:        "79cc9b6e4c41112c039af269f4fe1a1378e59a30aaa8059a1b74bf3d953a8361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774a8ea3e0de19ce9e66108a83c6856d610df39b2aec9d23c0dd86956b052983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774a8ea3e0de19ce9e66108a83c6856d610df39b2aec9d23c0dd86956b052983"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
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
