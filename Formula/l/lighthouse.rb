class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "13744ef206244957c48a7af3c7b43ae84878216a8f57040032ed742658713d37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c8759ee0744284af7b08614ecdfc5d76c79747ab3b4007b613a4fdcc555cff9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efb1934dc2cf3963d756fff29a9a16a798d2680b7c6c175f522af5ab7d97e832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c4a8e5934d9ea6d846b9e4f6306a26128375731ac4bfecb3e19e7632a256b46"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ab424cb92df92e7b50d12879d711d19dc40c3ee3a4e8727bc0d863738445542"
    sha256 cellar: :any_skip_relocation, ventura:        "49953ca961426b9d9523ba9a08e6fda0b9ffbad1ff91cbb092dc6b128b7ddb65"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce7388746eba5dcb37907347431bc2898260ee89ff8a3f4779e9d1d720fcca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd245d8ff45af0669b4d29240e9e3f10367cd42eaf93bd6c614fc2dc5ef7afe"
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
