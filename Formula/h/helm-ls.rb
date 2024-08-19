class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "1976d8f53c14c0467ef3be31ce425d291694ae8500c9d9bdbaf224b85c6f5d47"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30b411187cc1278453763bd2f10df9f3dee8ebe0185f927531f6fd9927b977d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb666d62a99dfe042d3f3e1d4eba3eacba63c939c351a2c137de5c534729fb18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "145dec6f93e86fe0064876210be9945aebf18bb8e6e889ef043e465ae882a86b"
    sha256 cellar: :any_skip_relocation, sonoma:         "447d4f02619728a5a9b5533f8a2100eba4cbc284aa1d21b6056e7e9ca317970c"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d88152685f6c3f93aef3925b2cedc5b0b2abd952c85c9befe8725d94379772"
    sha256 cellar: :any_skip_relocation, monterey:       "e59dfcc38cbd5721dcc00c70c5d1808613ca41c62382fed97b43c59bce733cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1974d8e2c7c7e5774f50044e8784cf0a13d12817c24f97b3abe93814e5d9a200"
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
