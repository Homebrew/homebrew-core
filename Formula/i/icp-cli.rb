class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "2fc9bd290ed6ffe94f401d16e5c244e6cd77bf3c710ff74f55d3e60db6b8c41f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2618b9c4d551018615c43b9c152c3a56ed1c4895f318dcd9b719e81d74656f9a"
    sha256 cellar: :any,                 arm64_sequoia: "699114a5e1cb3a4b5e3cba159d785110677e0c8a950069593a735e5097b4188b"
    sha256 cellar: :any,                 arm64_sonoma:  "49f50976520c1e827bc16c1d0f17dd2a661310f1dd89a99812f51defc76baf28"
    sha256 cellar: :any,                 sonoma:        "682183cd0c221a621c62ffdaef9f320f32f1585d71de0054e1f5b6b62578abb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc1a6a1c5d32e8d7748194300fc464dae7e21046d62ee7c7a024dbe6830c864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a123fbeeaf6440e1ddd5dd27b5f20f49d0d931a617af59896365f7f8aef04c"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix

    # Skip wasm32-wasip2 test fixture build in icp-sync-plugin (only used in tests)
    # https://github.com/dfinity/icp-cli/issues/543
    inreplace "crates/icp-sync-plugin/build.rs", "build_test_fixture();", ""

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
