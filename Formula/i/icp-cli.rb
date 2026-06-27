class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e22b6ddbfadf6cc71c64129584e36cd421360b80ae32e6544a53380a1adec25d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8b381a0b59a06a8cc1b6b99ce45ddc5fcd69d9a7ad36bdfe522ce253b0c390b"
    sha256 cellar: :any, arm64_sequoia: "83fce5eb8e72dfd1b6e6c174973e163f799de2464bfe045a408873b81bedbbdc"
    sha256 cellar: :any, arm64_sonoma:  "c97e47c43ac3cb48ad03a27d3b00d51450ec9ce042b9206d6bd9359145979802"
    sha256 cellar: :any, sonoma:        "726d8e2c8714d6926f4caf8ade0414e9330bd3cf55a9c0ec40249696be5d0f46"
    sha256 cellar: :any, arm64_linux:   "b4262092c976ba4037bc943e52df94dc304d32dd376630bf70d1636b92b7e626"
    sha256 cellar: :any, x86_64_linux:  "ad07962894436e153522f75221859e1c712a4ca127bc03fd247bd06d1d8fe2d6"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
