class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b00eff8853b33d12d0e2b02e49a5a63e1273ff4decaf63ca2afbe066a12d4f0b"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846aae040f43d7597dd50fc24ae0e3434c060228dfb5ffda404a8c46c1cbb3ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc8bed7d6943b0930e36895df1bf72aa16460569e461da69fb939d46428e10b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd78ee121033e1fbf8078ba1f04b59440627900e1caeb73451f5779d99ab6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6b91b7cb9e4b864b6bd1285123b18670ec4ebbb6f65593c29294bef54adc78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1405f22c1ac4b3d0f54b2c4e3540a05d274b54e7d841d1d1f804806222c9d59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3025754aa64fd2ddcb02cb5f6350da92ebb9bbd588aca8f9aa32b9231f3a461"
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
