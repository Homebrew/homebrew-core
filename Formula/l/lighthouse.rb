class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "8a8f43f099bed624318aaabbf3811e78a0171c7fb4e5e30f7e66ab70bbe40a1c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d954767cb910dab184563e101c3e2934e51287e6b3ba9f553b8c971793ff312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525081531d039db97d4c886d50c9fdf833d16e96615a9e2c7a2437c46f3f366e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ac78b89e96056435847f5af0df3793fc282cb94a5ef17f6bf307a56ef231fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d405ce97f4d561c210dd94989f083c23410424a55654243a4b2094777f193b"
    sha256 cellar: :any_skip_relocation, ventura:       "32cd06195c94fef42f6078342ab25184595d6b29a3b671db7e94ec7160c1cfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67153d7446c16ed236cc6c540860604e961ab04791e1b634ec0f1d23ca26f27"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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

    (testpath/"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http://localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
