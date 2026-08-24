class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6451d7e64f25232000899b05b68c87b93ca0710116371c4b5650e33c75b1b951"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aa3be4428be756d29f2caf2395483de580ada37d872ebe16f5a23e2d19b4d114"
    sha256 cellar: :any, arm64_sequoia: "392a2338797094db589eb10499d91f4bcc44b2cbcd3dce9ca66eae00491f04fd"
    sha256 cellar: :any, arm64_sonoma:  "4d10330b09a08811a3242e5fb0745d1e93bf78a5ba1e02458309c9130696e0f9"
    sha256 cellar: :any, sonoma:        "1d3c22ed16821862f2637f5188a7c1826526503b2b21d628607e912c1e9051f4"
    sha256 cellar: :any, arm64_linux:   "1ccc9899e5729a5a9079f0b5608de67687060dbd0db73ea623607131e2e01aeb"
    sha256 cellar: :any, x86_64_linux:  "d403435a94aa22ce50aa902b8faa12f5959524dce1970f4c745982827618b7bc"
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
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
