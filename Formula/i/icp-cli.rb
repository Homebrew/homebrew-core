class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "2fc9bd290ed6ffe94f401d16e5c244e6cd77bf3c710ff74f55d3e60db6b8c41f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0275138f2be6a67633f8126dc71e6d5bd3b4672e924c24aa42b9a1500d08f00"
    sha256 cellar: :any,                 arm64_sequoia: "76a9f32f8003c5784d51635caf66b7c1c8d7c1c24ae1578ccb629f524652134c"
    sha256 cellar: :any,                 arm64_sonoma:  "0376ecbc267d90e71ebbbfbda4b49a1d7f5ea62e200593b6020aefd53c0ca433"
    sha256 cellar: :any,                 sonoma:        "74740fa36f35f7e3dfc6d6f62fdabaf2153e502846f7f15b2998f457764a8009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e28e3d6500cfc08ccdb6ac8b80ba167834bb9cce3df21b7dd983b16fedf372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e394476677b1977fdc8d9e7c7e37c4c7af576ed240a30f4d6c9b212509cdd3e"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
