class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ec657884a80b1a11ebccf9ec887462ccedbb9c7a4352a26da5dcf9ba2fc5bd58"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab50232100dee21f99e4e317068fb86bad9d53ec2c0c13a05efb1da9b53cc1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67831fe452bb9b78f1071493813f266cbd5370df38d73f8a8b67d9219eac70c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1725fbbe14d8166ea3c7920de01086846203ee2efa7fa5bc4842b10d91e9445"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06431b2589e0963ac80e441d4529428a1d0dd0dd635badec19dff583f68bae9"
    sha256 cellar: :any_skip_relocation, ventura:       "2e186c39f1c27c29e2e6874b9acf96d363e5f51eb1067ac6e6ea1cb1203f0931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97abee4c6be9f4f8b3ec7723e67f11dfac64da19e0274f2e580de4814ee46e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5359e6a93186883adff4eb82fab27d9b1019f85497df5b13348853cc11d341b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
