class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ec657884a80b1a11ebccf9ec887462ccedbb9c7a4352a26da5dcf9ba2fc5bd58"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3b1b2342f82cae4bb20c7e81b722abe1fc927f794268b39f0209c84a60eb98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1f7cc3336b13405e986e1b6e9f8353e023b8be82a51e098b8a1a9776edd72b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b70dede07ff56d639f3afd944850618e79cab5c4b93c21c60ecd33b00058042d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be92bc0dcca4ddaa696cfa662a6f6eea33a27bbec772fa8129bd44a0b0eaec0"
    sha256 cellar: :any_skip_relocation, ventura:       "fc9ade46aae0a06ecb77087e67a0ace2dea81f9d3ff02b1ca1403af6ac51fd2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f678d03ceffd1bc121a0257e4a08c72ad79ab602ac49ecd3a052a1f9d63459e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5098d3c6b1137117436b5f8a6d978634e628eb637b9e922d94cf6771c1d875"
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
