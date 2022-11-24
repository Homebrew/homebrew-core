class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "c5e62dae1fe96694c4f04af4b177c8b5f7cddd9d0f6090428028b07240917393"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7f91a9dc986c4c3766adc7c42f4ccd10f7fbfd1f54c19dd91e58ed3265e2734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e97e06309659ec22be961393729af9b600962b43da5071375bf42e42a81a07a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f67c81b06f3bf756196c67b0b110eb7686430499a1319710eb7d29b396f43e"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5775821769a54d8c082bdeaee582fee13611dcbfc9897cbbf33c33cc36102f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d51148a54f16d1ab0d7d4b85c212c1e7a1243300938d36483350dfe2d0b2819"
    sha256 cellar: :any_skip_relocation, catalina:       "deca7f84451bf302c6a72e29f70f0c4746c7be26bc93d0fd85b85030f7f15861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262d82175ed4c9281fd4f61f105d74aa85b8a80cfa9a91d33904beff12a04c59"
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
