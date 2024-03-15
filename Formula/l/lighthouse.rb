class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "8250a5a117b236dc2801a24f766a46d1581d5d51d168a49589eb2d56784bbf8b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db7ad6cc06401287a95379ef6989e08411f447223ab892ca28ac2063ebf7298b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f435e23a43bec765106d1f2444147a8c8f42af7479f0644664842cde665173a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1585f9e9c54dd292304de150a5d3d9ee615416f040de0f462d3875a4f19897aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "16792297a86b7f0965a567bca30ddb08ad9bdab1846d7021b36d0a513ea6b746"
    sha256 cellar: :any_skip_relocation, ventura:        "84bace2438c528d243cfc02d9fd7c45e116daa6d85f1188a3168bf61c369c4ef"
    sha256 cellar: :any_skip_relocation, monterey:       "24bb6b28c290576221c0f73d645c5f6826fea5f12d2d4dff9a569eb9eeb221bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba15a07cb0ce5a9f7293ec9ac7ad097ff6cef059075b2c5f9a81e9a6695fdda"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node",
           "--http", "--http-port=#{http_port}", "--port=#{free_port}", "--allow-insecure-genesis-sync"
    end
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
