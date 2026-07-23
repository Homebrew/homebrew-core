class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b836cdd99003b492074d942c39e0fc79780399a2a843ab7297ef493a3d9e5aa5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "54a5099085e85ccc99f6ac7f85088346f90835fc6825defe52e5eb12b785ee91"
    sha256 cellar: :any, arm64_sequoia: "c2cda4cea842b29824e406b3b700151fad81664a944b57d27afbbd9737c5ff4a"
    sha256 cellar: :any, arm64_sonoma:  "5616c2d9ae2bcde7aaf379a95c8474c99d1a7367a408624914e289fe4111b36e"
    sha256 cellar: :any, sonoma:        "d048dc5cbef6727938f7184f8bfadbbf8072fab508a9420b144085aeffd73d8d"
    sha256 cellar: :any, arm64_linux:   "6b2d4f63d13580afda0e0d6834ecf0d406de11db42624ad3d2e195fd0a3228a3"
    sha256 cellar: :any, x86_64_linux:  "cd9ab254228b71b5a747ed9117e7d2ca367b2452fad91c264a95b8ef3cc9e789"
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
