class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "1d14834fc6157ae76a889644ef3d0be4ebd7025e161975a38254361ee000886b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135f211dc95caed3113ea628b276c28f12fe6822f8d218bf32b93eeb35d102a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443f77695187e65eedc532a07ef3bcd7839807f5f49a160355054d56bd680c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5652f2a6ad850c03b04bbf6f66db22d80974873d2888143df58086d49e02c8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c65971f9ec95e28c03e67b88e680c94a76f57640bb9d148f8d6376c95683d5"
    sha256 cellar: :any_skip_relocation, ventura:       "65b3df6d77c81b8e0cbe540410a4e9b83d308413d038d1abf4adb978c2339af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5247ea2d2706c841aad73816a1fabd04ac5f0909f740fa43b46f484bbcb43b63"
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
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

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
