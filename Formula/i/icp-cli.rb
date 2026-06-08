class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "62813d08886f2b331a310ad2aed0428f1bc5d480f7530c5e7aca6e8a7abf2193"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3d0a07a7174ca103fffea5f07041881db07c5e38755b82b53b3d74b3c3ffd58"
    sha256 cellar: :any, arm64_sequoia: "cfebad17cef238b6dbee6e2b8f5f72be6cdb423de713b26524ea1dbea7eeb84d"
    sha256 cellar: :any, arm64_sonoma:  "49fd232c55f27da69c61e9d383447cc5e8ace918ee79ca9649c49804a6e73e56"
    sha256 cellar: :any, sonoma:        "19a7993111c191c7cc15b76c78df85ada29ad496ffc2d887863448191521e3f7"
    sha256 cellar: :any, arm64_linux:   "9331b263318c70490a77b8bc0ab52a8f237f131f0c19dfea6bfff2db5ba83a34"
    sha256 cellar: :any, x86_64_linux:  "7660135cdbdd6a0392d99442af98fd8f525d8c8100cfbd5bbc1197d193838742"
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
