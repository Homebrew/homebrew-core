class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4536eef7d477ad003dcce0b63da8cc5c48b7aa82b194e3198c63a0275eb8b1d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "903d119fc57276078cfff33ef3daeb007795b6c3d304c29c0174d2708c0e44dc"
    sha256 cellar: :any, arm64_tahoe:       "a915e90f32895374774ea34a08c99d5e2bca064109190185b52f7c978ec6e916"
    sha256 cellar: :any, arm64_sequoia:     "daf897a6d8d223ff0df6d3d07eb03a9996f5ef8971058c0aaa8710eaf7ea1b2d"
    sha256 cellar: :any, arm64_sonoma:      "56fb19618eaf0bf22e7ea27d6e60a46819123cb2042caa88c92da71a9010a149"
    sha256 cellar: :any, arm64_linux:       "f96d106a7e305146ce23c6c2db69e6ae5955553823a054ab2b437ae9fe89da87"
    sha256 cellar: :any, x86_64_linux:      "166bea812c67463e9d29c2174385698f03734e11c810b2707d8b884afc561291"
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
