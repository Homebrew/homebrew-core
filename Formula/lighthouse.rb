class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "c5e62dae1fe96694c4f04af4b177c8b5f7cddd9d0f6090428028b07240917393"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de279258de841e31f1b679244dd81dfe67d34861a73af11c93018bbd75f472bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed85bf84aba8144ee6650abaa008c623ed81a4e617f672a680c4d85d17f845e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd4369150d6eeac3f8b9fe0fcb30eb8a6826ce0f32d9d3f48d3fc398c59876c"
    sha256 cellar: :any_skip_relocation, monterey:       "40d512b3861a8a6052398b543861b9f34e5b20b611724f8a266672d681e7dc23"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03d65e6b209004d1e3f2f0981a3cf649e229f7929fd8527dcfe6e99c648922f"
    sha256 cellar: :any_skip_relocation, catalina:       "71035c08851564e4c9bde0179376814aa275915ae9f19a18ae68d6f159699575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3e78abb30755a1119d0bd4715bdf3a1dc0b23d8683bc68122f9ea6a201550f"
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
