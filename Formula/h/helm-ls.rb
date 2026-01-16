class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "a8a5490084839af3506c85efcf603fbd71bb9ee37222bbd7817da1da3f054ab3"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20bdf67a7e0236a71291e8859150a4881cb20f47f18291053c069a75c3f7cf2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33272118580434420cd9afeb6d1b3b9c2a99197f11cf1ebdb5a6cf3b5108c924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945a15cc2432578822c0133e2391cc526775455c0606e4271a577d66cb06db5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c283d2a66a8ac927eb6823d3936237bb5c09b106621972512720ba83f5ce894d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a7d9b12fb83c20cf9d8af4c64e33f62d5b427c155e6225c9f7579187b132d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27695f6754f9efdd600932665de44b3e4cbd02f87ee95e69a639db027f8620b0"
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

    generate_completions_from_executable(bin/"helm_ls", shell_parameter_format: :cobra)
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
