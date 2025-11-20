class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "f3b537f579f29fa27fd2ad3bcf4746d062301151e5c599506551bfbbb0f030bb"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c13b254c0e9d243a5fb0c77cbd8b5afe0cca165a9e413f58b630f1b60a5d0245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58113a989f3c339fcb09e78939ecf2ca3357c99416ebe90f4196e494da44f2f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3066f5992195aed3281464314598b1f78a8475f71563dc028d1b5a06edf25b2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2d743c04c5aa7c9962e9aad5007022b360fa8c83ee44c9d2f8a71336bf3c16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca2fbc20463ddceaa496135bdda8a128a576ff50cf303e5fb2b6ff41acd0520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44df30fd0af57897671c16ce5a9d9624daf7598a701005a2bca32b5b8970b181"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
