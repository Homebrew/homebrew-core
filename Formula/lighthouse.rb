class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "27461dcad6fdfe2e818591e22bc5aa66c4b195f650096a7321f8d08556068c3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579f72b496e25b6a519be64e70ba3886a527e6dad0480a35b3b7122d39498af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba69e70a35e942f0da454927c01eb60ba529f5d183995ee906663da877823a1"
    sha256 cellar: :any_skip_relocation, monterey:       "58239ff5ddb03fed20426626a137455b5b895e4c8a88eb4a3a37feebbe493b5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e2a45df8529aeaa7d36919dd6bd7e207baafec0781b599b9b0ffa74063730ff"
    sha256 cellar: :any_skip_relocation, catalina:       "43a3c4a3d99360765b93c5a5a0b7aafe0fbd63b6d170e3eb0eec8b7b871c66fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce09cd835eb8cc10c20fa87dddd236d15d6164401a860196d1d723d14f6c760e"
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
