class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "280871ad806a210755e6f4dac36a0ca4e5e1cee4612de08c3b472667ab91ecdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4bfd295186cd30c89168e1a09ee5c9f4e5270fb6c53934e612c1db47fcc9808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7096ad4444c93a1d4e02d2592d62d84597019dd4785399f54f5e4942c2d307a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4caf904fbb6edc3ebb9dae70c327290a1c3263c26578fa9e0dab7a081ef9f58e"
    sha256 cellar: :any_skip_relocation, ventura:        "516bea57db3ca31e7c7ed8328381c00b02e9f27a93aefc5e9d433d36e9304a31"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd170af6111da4832cb1f419cb11730948e2be88ad0bacb78273450e472ff9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba866722935059df3b9a197a18e248adf147dada0fa91ab8fa6163e00d7d8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ae6d09fd116fb4f6198a28b045d276b5f35e63fcdd78c8eb8fbda62a8075ecc"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
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
