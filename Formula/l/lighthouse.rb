class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "ffb7260e737b32adb4ca61fa6067da741b5b4bae7c7221057983407b424ab09b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "133ab02648c0d25925770c3904f871624cbf503568a11f5d21c2c39163939386"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7127567302334b257907272bb0b685085ee80ce0bee19d86250cc4d1149daea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3afbd8e82abf94aeebe948057f56b7542718d898710988da0f6b59c1bf8d363"
    sha256 cellar: :any_skip_relocation, ventura:        "9cab170aa53b2d9f249513f8291bb16df52ce6ecfd249b5f9407f55c00e67f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "581d2c4a76655c1c77cb16321b5068b274baf3d9c4d16a3a22b08c8082b0ea13"
    sha256 cellar: :any_skip_relocation, big_sur:        "a208fd283098ac9534ae11131419b10143571bed627dc48d0ef346ca10b97745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "286d1f2bdcb37fac03b46eb315ff24c667f19951434f066cdb8eb5d9957cb3c4"
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
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
