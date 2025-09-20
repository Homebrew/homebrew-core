class Agave < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "b8873dd5ca0d2e210eafc3cab64c6f0528a9cb00379b1baa8384f4f6f13495c2"
  license "Apache-2.0"

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rustup" => :build # rustup is essential for building and cannot be replaced by rust

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd"
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    %w[
      cli
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      tokens
      watchtower
      validator
      ledger-tool
      rbpf-cli
      bench-tps
      dos
      genesis
      gossip
      platform-tools-sdk/cargo-build-sbf
      platform-tools-sdk/cargo-test-sbf
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
    system "cargo", "install", "--no-default-features",
      "--bin", "solana-test-validator", *std_cargo_args(path: "validator")
  end

  test do
    assert_match "Generating a new keypair",
    shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
