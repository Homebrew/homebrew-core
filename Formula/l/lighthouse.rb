class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "e5cc916f78235721d2ae3db510ec1eba88687c7d4abf469eb0e8a1fe51714a69"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87260da7a34aff640c34ba3c6332d60b4d5deb1c6cad6e95db9d15ebfd91a60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "148f00476b17df9136c8526c696b930aa6e99c55fa448afc2e8107259516e1f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f280cb9a23094f0c42cbe338ecf3dcf666e259f47000e9a3aa3a3d1a768d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6ff32713f4a4c673b74d3fd1929e1f3f8dea1341893e274c22f1bb8cdc97b9c"
    sha256 cellar: :any_skip_relocation, ventura:        "eae113c8f1732c30f3faa958600cdc687fc90df782b480f1e598e3e1ed00411a"
    sha256 cellar: :any_skip_relocation, monterey:       "3dbeb0ed428b19d0c54175571dced013ccc7f43f3e6c4ff11a53048a9664833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66818f29bd3159b83a977f9d2330cb539b8ab5f63757f5a9de25af3991b5fec1"
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
