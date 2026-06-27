class DockerLanguageServer < Formula
  desc "Language server for Dockerfiles, Compose files, and Bake files"
  homepage "https://www.docker.com"
  url "https://github.com/docker/docker-language-server/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "df94194ce63f0a1217944c72b941a842101aee7b7dd16018d71818d070d146a8"
  license "Apache-2.0"
  head "https://github.com/docker/docker-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f35fa22edae4c8555d7604dcce4846ad24cd2a6400938fd9ff396042fc9ab748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35fa22edae4c8555d7604dcce4846ad24cd2a6400938fd9ff396042fc9ab748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f35fa22edae4c8555d7604dcce4846ad24cd2a6400938fd9ff396042fc9ab748"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a008395ecac3b130dc18c332b53acddcfc6ef0375cebe9e9ff8170c0f61f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2eac8a43c55f2a94541d50cca86e38b469e8715faf61e5747f37470b6e1fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b4ae8d0d220708c044e47d66d819d99cef0b2ed82743827643320fb9ac400b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-language-server/internal/pkg/cli/metadata.Version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-language-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-language-server --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("docker-language-server", "start", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
