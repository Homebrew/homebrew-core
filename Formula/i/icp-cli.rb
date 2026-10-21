class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "6ab68c9276ddbe34ddfe4b82cb4343b4705cf57777f00aa28479e515569d7be2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dd7d0ce352d0d8da1800b41a525b7bfc87f6403aa461328a16114fa119b8f901"
    sha256 cellar: :any, arm64_tahoe:       "7902fa9fd3f4014517878bf0b07bc14aa29385227debc9979022bf2112cf2f91"
    sha256 cellar: :any, arm64_sequoia:     "48a4ea9fdc59989e4cc8239a6899cb93a73329bcada4d1ee9e18cd7ec3a444d8"
    sha256 cellar: :any, arm64_linux:       "0d3752add32a4eaae0059f524fcbc274e55c668ccc0912d1b4f1b38b54d080c2"
    sha256 cellar: :any, x86_64_linux:      "15428e31f81ba03e28aac554241af0355d5e07bde5ff76bad83001d19b1a9e74"
  end

  depends_on "lld" => :build # for `wasm-ld`
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
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
    ENV["CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER"] = "wasm-ld"
    ENV.append_to_rustflags "--sysroot #{HOMEBREW_PREFIX}"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
    generate_completions_from_executable(bin/"icp", shell_parameter_format: :clap)
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
