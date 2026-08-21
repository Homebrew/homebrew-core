class Lspmux < Formula
  desc "Share one language instance between multiple LSP clients to save resources"
  homepage "https://codeberg.org/p2502/lspmux"
  url "https://codeberg.org/p2502/lspmux/archive/v0.3.0.tar.gz"
  sha256 "28caab4a2f74dc4b8117ac5eed3af2b30258eab1affb47f47363afece0982243"
  license "EUPL-1.2"
  head "https://codeberg.org/p2502/lspmux.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6b268e66689a372808bdd6f377c76ca5ab66b7fea7952d9769babf50e96fe0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a5820e425d62ac80fdca33bafec1d9dfabb210534d23be782a51032d129e84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6179b5dce04784dbf17453fa430b689a2a0847d824b0bda507d86db199205239"
    sha256 cellar: :any_skip_relocation, sonoma:        "24990bb9a334b6327a23db0292983ba8d58a535c54df0d35a098ec519cff5551"
    sha256 cellar: :any,                 arm64_linux:   "58afbc06899b1680222ee6ca9cf286f38c3005897d63a392c1b40645bdf6a5ed"
    sha256 cellar: :any,                 x86_64_linux:  "7ea6fe0e8e7e4e0bb918ea9dcdf20a14844df4299a63ab437ecb20bfc5391c51"
  end

  depends_on "rust" => :build
  depends_on "rust-analyzer"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"lspmux", "server"]
    keep_alive true
    error_log_path var/"log/lspmux.log"
    log_path var/"log/lspmux.log"

    # Need cargo and rust-analyzer in PATH
    environment_variables PATH: std_service_path_env
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": null,
          "initializationOptions": {},
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 2,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    begin
      pid = spawn bin/"lspmux", "server"
      sleep 5
      assert_match output, pipe_output(bin/"lspmux", input, 0)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
