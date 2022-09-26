class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "7fc8b408d5319cb7cf80257a5a8daa38677f2798452e236f299d219d57730993"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f386a2642b5dfe5206f877994b6ac67c02c130fda09962d2525b2da8195746c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65e85dcad9fc62baf866cd5a6b8d5e7f296d98bbe48e8ddcc342fead96706d74"
    sha256 cellar: :any_skip_relocation, monterey:       "126a7548cd7f191b9e4b601b4ffc4c4c22d05e2b9cb9bf7ec630cce8ba1027f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "89f923022491e7f8af2e7126b55dd84b66979a2fd1935a735ece6974e57e40aa"
    sha256 cellar: :any_skip_relocation, catalina:       "5742fe68e687a6d40dd8677da8c52accfddb752ca8598ee3f8d7964eee52dc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e9f6dfde40d582ca2b8094a6ad7b9b2e33a4c3f245bd8d227a37dd07e9ff4d"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
