class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "bfd44a327f9f45dc695a0e65ff47dfc8c40aade65fe4fce92159de9763e6a54d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f5cb7ec619a16adc02984c0f6ae1493fcfb6ebda97eceac2e377d06b191f2e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1fb53b6a05f614bfd0e41aaa652821b5037c7f44b361adf8561146352634ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12e2e3baa4e14adfaec48a74e3a30fc65393cffa4a43dbc5004679b8e341173e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d8d457387c6185e4da88a43f014026263c0906f2b5c2a8cb79c3bb79c20021b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05b15adecdc306c09f4fc0f47a3bf301cd48333968413ecde6702574eac28f6"
    sha256 cellar: :any_skip_relocation, ventura:        "9666481acaabc2dc1b515c024c36929a16198c2c4741fd4031b92623af38921e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e7f0fb9a7e98068b3d7269e2f37cf477ef2224710071ac6222b13e6d2f3aba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7236cd83d1a440ff14b712cc10628b24770f3fef377126e8ad9145f0112ac1c6"
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
