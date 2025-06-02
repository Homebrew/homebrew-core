class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8e63cc617848f7559a378fa50507f38a03def59ed320d6d52769773bc2114af3"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd82c179f05acf34735052fca6cd50f819d37f37558594b800c1b4f09429d2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2ddb55106dc0bb1b69d58b3c756b7ee66a662f554c7e48f50620fd2a994698"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e1557dcda63f114e18dc2c444175d10561f363af4983b496f0c8ed08084535"
    sha256 cellar: :any_skip_relocation, sonoma:        "c435f2165ded93b57f88bc2f565a1a8be5f4f912503a0fc109ba9f08c0660992"
    sha256 cellar: :any_skip_relocation, ventura:       "1e082975114561b00e52af3461edf1dd7d643e548c4d671a9e0c69606ff4f4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf802af978988e242ad96709dd5572226dbb4a68c121970bd8624d980b7a26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8509e01883ba836a9fb60ef9e72c50c9585dd88c25742fff421bffba916291ee"
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
