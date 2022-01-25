class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f7c58f648b70a39db424963642a8c30d0a2dee65c58c3f2122f2e8fab191e83f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d9dc6001f7799bf89b8c7ec53d553f233eefbd6c040897407958581e93ca9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecb1a33d3e14f0727a50e9db5c8b95b70a9631d913075a17263b967b443267c"
    sha256 cellar: :any_skip_relocation, monterey:       "be75c80b6efc13fb307f2f405b9b98c23f16745820ec7d770c273d49346a7c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d83742f33ea75156fe4137bea78851c9d3b12b9e558875b8c9f5d8bfc840e37"
    sha256 cellar: :any_skip_relocation, catalina:       "73a9b71a518fe53ee0d350dfd041d57d0437b99f8c8e794e240626f128ae2977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd46e441706f5e73ca2a0136ccb42b436a60fb51f2afc8a51c186fb77b03a09"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
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
