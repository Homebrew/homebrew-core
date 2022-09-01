class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "53a9be30f59d6d115dd2d5ad49145c103f93daee4a85f0d49ba060ad2c7adbd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc91b9a07d7f9e6801375089fe8a63f5c6588ecbf819b4c8908bb1af81cc2409"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39ae8f8a39af2d9acb44912007f921a8180e4cf6115ec831c971e1916e44e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "5f29f04cb222fbdbd2f14ccb8ee7a29fcc0942e5ab94f2472969c215fc65a854"
    sha256 cellar: :any_skip_relocation, big_sur:        "5af01c7c8db68767e62fd0042d4284eb9be18dbd8b3b74605301eb8274c1a6f0"
    sha256 cellar: :any_skip_relocation, catalina:       "fe8d7719495cee8ebe52fb0c9c3696d12f4193128026b11da87ae7481f36e23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b63672dfeaf18b689067c78bd36a15bc1e0c283839646446acb7101747d5047"
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
