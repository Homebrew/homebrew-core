class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "7a60745ee147fe72a0fd9d0b3d21b9e3fd1e998002cc871580477664d57bddc3"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "412f84e01c9bdaa69b59286e2e4f4d042e026d7746c3dbae4b350f72a1739567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "029c5ccbb6e35fb27d061ba9ca121f422c0f7705083c190d5b419b3afeae4d1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9db74cef32b830277fd6e32e794f90eb98b825a7ebb289c40678bb24169e1c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "514da2baf67bef715fb78c3d9750e1e8f94f266cbb6ed40c6bf46ef22ae762de"
    sha256 cellar: :any_skip_relocation, ventura:        "d725f0127e0dd39112e7be66f16150cc7f8b327f6b90af355412422d83664ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "893207e9b9e23185d64f5a36813b90d5f10f07c2b7463d304a5dfe401738259d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a40685921bc0008a7dfb3e8ef8cce8edae9c4af68d573549d4b87650a9658b4"
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
