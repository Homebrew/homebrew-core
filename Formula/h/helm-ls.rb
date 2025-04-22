class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "76e549acedafcd69b7bc596f8c8e3a956ea8d5ac7701000e5128b8ec256c0b3a"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bb03997b543932896560f42ce13531551f618832b1a7773bdb54ad6a81073e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a893874fa616f619ab909de66cba55168200fe6de3aae3e559c6fbb98a1f64f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ed3ac44342a67beebbf851a340acb32ddb57427a0e7244dca136546e6f23ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "255c0e4b69864916a7147768dd9d2d548d2c27bb9d8033fda8dc92a72b2af6ce"
    sha256 cellar: :any_skip_relocation, ventura:       "50f1c338d0bae3c40bacf2a6cd4f98c619c98a87754364ba9a2cbc79adc8350a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa90469047d8a26ff7a72fdedf73d7afad79294fb6fc4c2dc6eed447628574da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d76e2694fc0a48bc321a22a50e8f9b67e91dc5168a17aed6598a9b764ffac5"
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
