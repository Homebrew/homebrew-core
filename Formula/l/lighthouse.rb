class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.3.0.tar.gz"
  sha256 "25795f57bc87fb520196f50c2d83f8ff908a84dbb2604da295cc8dbb5dd9a03e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7bce92fbc13f25d9d8ff2b6df477a7c2f83e340aac61f172e388494d55f3203c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92cf1bb57d56f7c63800b55d989f6ead70e3481865d9406643e01a53669f362e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba5b8ab77c10a39fb88a29b4e08d3b7f2b28ff57a2e81cc95851d082aefd3cf4"
    sha256 cellar: :any,                 arm64_linux:       "7b8975412c2ca2d05a380073c4948b64a9dc381929661b6d167cb7a112dea0da"
    sha256 cellar: :any,                 x86_64_linux:      "05a13769a0a3e53f393de551f4ad45e26f0f13947dcd5175909fdcde1d82b126"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "lighthouse")
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
      "--allow-insecure-genesis-sync", "--ignore-ws-check", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
