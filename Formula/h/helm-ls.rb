class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "7274febf905cfce43cd58576caea56b38c71eb9783f2360283b123a5a0e0b2e4"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0df3c8cee1bdaa3779d2535f425eaef8206b4e6d83f1d1ae3087985f62e9d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5d369208648ea59bd1def9af30c0d7cc33df9b619ebc1944958af627c51869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed378c5a4bc785008089d388f6cc34ee3b6fc7a4ab400557e4b685da85f597b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9db95ae5e8843df0d58b2cf1d29a4934f46a1ad3a933da3c87ff6f5983cc5a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f6aabe80397fd4720ff45c64e869540f246d5972a3a586a9d08822ce5affa0bb"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab555b2ae4ee2b81a63fc330752dcd15d8cb66e7a892e0b733d97f4260d91bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c363dd25877f013e97940699ca517f38ff39ffbf451bb66ab499024520a7fd66"
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
