class DockerLanguageServer < Formula
  desc "Language server for Dockerfiles, Compose files, and Bake files"
  homepage "https://www.docker.com"
  url "https://github.com/docker/docker-language-server/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "f5dc558745a7a7324fd496a613f2ff3ada179f94499cbd3427d18f5c08d9d31f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "749bf6f4fd3fab89f4571208ff1748ff4002d0614ea4f7469c74eabef4eedb89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efd5817ad29b5c1f08f19b03b566a6a6ebcce6b21a698c4e4eac8b2481d1fdd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea8b95be41f9ace28ef2b49b515fdd250d705c42ffec78c9c084ee57f38af014"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8cbabf65becba1bab7aa2c72e9cdaaf122bf1a07a7556f993da75e619772d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5f2a2ceb9aff08d2934e3954bc4d4c32b4b946cfe09c6f10a85876e0b9ced559"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/docker/docker-language-server/internal/pkg/cli/metadata.Version=v#{version}]

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
