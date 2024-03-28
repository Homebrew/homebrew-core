class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "e33edf3636ff435706eeb03f4ce9cad4abd939ddfc4b3156944f8b56695f734e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f01b35a0725f46719addc09b52ff2a5dae3e4a77b94a2651a712e3a0736b264f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c39ea65940b900650a53e0d6f943ab06a0ad6ac8e8d583f017eb0a4b97f4b4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c285f47bf56941271a4f0a834c1c72fb9ef8310160966c3f12591d2fa937a9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7005dc92f8543d84e42336cf869beee08e24148a64ccfe127dfc2e4c5390c11"
    sha256 cellar: :any_skip_relocation, ventura:        "9a7385a0129fb6c93eefab465cd0136ec899681d33b856cd234cfcac726502aa"
    sha256 cellar: :any_skip_relocation, monterey:       "75c5b3cf0257bb232450872999ee41515f0b04887b1c995b40b76a675213872b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a10f7d02d89462e14cad0eaa588262f6c550f34bf471f5e1b2bbab2e940798cd"
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
