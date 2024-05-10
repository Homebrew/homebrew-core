class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "ac7ab98714d0166d0281ede19971634ecd51aa0b053ea3b8bd131b446fa9ea2e"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b444ad38606add6783695eff44900ca4c974a163854904a01878967724109ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9580fed83f178ba08fd151ff309e440ead0ed035382c2b4004dcc655c72da08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c807e0dc0d8a4e6cf6d3086e4715fc1a405b75382086809ab04a3115ef6a35bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "64e52b5b33b172f80a66dd5b78f366f638746216df6754380f21df0d22b6d316"
    sha256 cellar: :any_skip_relocation, ventura:        "4d500392bfa87183982b79b6b38f110a66271fac822f16ddf3be078a8ed1513b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e4da9e422f823daa25b47a44dd1e8b64d75b7f91f431413a752b2b33ff07a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8293ddab0e33101c26be427ddf55dc66fdad136803cdac4a4845bade4519e9b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.CompiledBy=#{tap.user}
      -X main.GitCommit=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"helm_ls")

    generate_completions_from_executable(bin/"helm_ls", "completion")
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output(bin/"helm_ls version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "workspaceFolders": [
            {
              "uri": "file://#{testpath}"
            }
          ],
          "capabilities": {}
        }
      }
    JSON

    File.write("Chart.yaml", "")

    Open3.popen3("#{bin}/helm_ls", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
