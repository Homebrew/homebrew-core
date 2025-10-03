class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "75da2b8c3397de3361c5e93d256b0d6d1666a83b4039ed5febf3df6ea9f73bc1"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d733a4cd347877da589931fb43b17795d59f22b64317a6f0ac58f5a6e866e896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd280e902cd6bee83a50efd9e84847ee06a012d32caf43524054470ff2e06e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c82928b7f9333c372ee3d3b2ab35ca9b310d1c9154bd009d03fcd58c3f5574"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef517a2220c34cf4d38249448c0d41e062d31d3ea821fe4b254eae4f94ba453"
    sha256 cellar: :any_skip_relocation, sonoma:        "26749a6dc3cec30e9d37033b409df7346661cbba8bf7867f0d00cab22979f3a0"
    sha256 cellar: :any_skip_relocation, ventura:       "2128dcf4e463a3298b29c3b4bf23651540354067626c2842507d5debcfaf010a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f8937a909f09051e33acf1f282c9da9faaabc657be936244170710fe08aca90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09504a5a5102786ea3efdbeffceb14446b859bed5e3979d0e33a07ae0d9898ac"
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

    assert_match version.to_s, shell_output("#{bin}/helm_ls version")

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
