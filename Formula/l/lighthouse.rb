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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b13bbc4acc4dbd8577a2253e8869be4aeac3105a35247ed7a326901f3ca0982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89d6a61ab56744adc4e692338aecef6aa5973730f55db2752df57ec8696e5f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5373829da179d1fd75ee6030166c478c35a1a5454bca8a6ed2b8cdaf4294cfe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f25215623aace8b7c19cdec00032fb3f0182137fb13597308052cbedf53bb3d7"
    sha256 cellar: :any_skip_relocation, ventura:        "7de02348e2fe57afd9465c85ec437ca40520c5d2465551873330415182233378"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2b1935636c63cb4344407ef9b3be8228b9cb0ea84cfbc781c5eeb83bc16b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ad0e0889c93a07aa5b76d2fae2dd1b17cfbb36b1324403d4fe4120926dcd21c"
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
