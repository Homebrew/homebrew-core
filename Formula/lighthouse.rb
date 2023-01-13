class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "828f29c0c7d6a0ed311f9e48e4718a8152703bfdd74dc724829760d91f2fd33d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e2184df5f5a1b626326933223a615316e6f80726cd755f904a5c8e355f0e89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16afbff027cb65406c830105a23ac7cc883a1564d77844cc1b2b27d3799b78a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf39a230ea3f75561a3873e3adde753282ad84a8dd3e031cb0a3684a64480899"
    sha256 cellar: :any_skip_relocation, ventura:        "46ee29ec03c0afe9771509dbf86a54d2410d87257092ded531bb34998da4c7d4"
    sha256 cellar: :any_skip_relocation, monterey:       "a7edef9ce2b2c169c7d5d10e3dde4e611dc3a3c6af72a6147164256e2e7f1ac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "473192d7dea04d61b703fd0f463c52bb5fc08ad68062e49973cd235b87bbcad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afaea56968d2d751edb71a448e50b4cf9877d7fca52b8a4bc674b173d45057b"
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
