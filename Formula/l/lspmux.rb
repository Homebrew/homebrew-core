class Lspmux < Formula
  desc "Share one language instance between multiple LSP clients to save resources"
  homepage "https://codeberg.org/p2502/lspmux"
  url "https://codeberg.org/p2502/lspmux/archive/v0.3.0.tar.gz"
  sha256 "92410dfcda4429e0463db91b67712da00fda5fa9fb5316174126e702eb988440"
  license "EUPL-1.2"
  head "https://codeberg.org/p2502/lspmux.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d37f6ac1c9841457e8533f39ca4b7090d6f7a0851722a8ed777677798b875f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9462e1c0d75511447c498250b269c59ce55b226c2badc3aa4ab2724ba0aa4883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44330c574fbf0a5c14eaa6b85d49a9510d856893c77fb10fe0e6015b1d3be4e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3304e7b57e6455f4a8deed2fc292bac9400d5ff0bbc84bd4a96f177b161f506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90116b031291bf519f529efac2ab4995b32408f4466121c4c0a756edd43a87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c45d94f75046f86d12aa28761fd4d29735598fec4277662d2a1f8f3511319c1"
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
