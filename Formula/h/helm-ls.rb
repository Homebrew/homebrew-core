class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "4674a2d22fcfe3e4d2dd92d35b143c4584b7ee3c30c20b42cc5518ec2562c69e"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57992a92ca747945c63537e3f4fcbf40215c414470dc305793f43dcca7e93d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2837ad40c79c143fa4daef390f7d9c978c2d8d116a6628ad3636f8c36797c85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e2b9b6d0d9629047e18853ca061285f515e33ec0f50b33d5d17ac99d6f80213"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f35d1ea06f0eed19a6cb1bef3737140705c920949bbd9396c34c0c53e2a27a0"
    sha256 cellar: :any_skip_relocation, ventura:        "e29e0901d20cb6b50923d284f225ad94ebca5628aec60697efd90da003b8d62a"
    sha256 cellar: :any_skip_relocation, monterey:       "e07bd439ef9f75b0efe9e0880b830e988e254c1fee7bf15314c910162fb3f788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01f7cdb0db0f7807d7837bc4571649163c5960ca42dd6c8fb3f7366839e8afe"
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
