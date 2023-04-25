class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "3347743b42d9cf40013536fbfba55189c91ab4b8690d0d3c73a0535455e6b73b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d83dc5d0f6249967ac6a30725673ab89d3c93fd9106f1362b8005f399d332365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4fe985553755946f97d44f1f811fc7ece9f96ad3014218d5b198c3539d3260"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496447f236ddf0553d38f4c17122532381441a342a7b42a5ed3ddcfc1c829051"
    sha256 cellar: :any_skip_relocation, ventura:        "72b3e6f038fa20141e342bcc702aecb8aa64cf8688849de3be4bfd2ffe5f4bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "670d407e67e437d66dada04a9aa3def9612e50f3e44444b59ee0879afbe804d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "43cf968b212c22ee8083190a49b41372f2d2808104b21322d66f75fb1489e41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea2fb261045148706a9b9f7a8f56d90d4e16c8de46b431b48a0cd9a97cdf6e4"
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
