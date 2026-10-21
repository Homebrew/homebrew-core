class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/otter-sec/anchor/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c346ba9189b0d3e500653fdf7331940b8bca9b2fbf7286c53976b9ac55b8975f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "c1eabe14272c725055816f60483a32c79a487fd327dd5641bd1584c942442d0d"
    sha256 arm64_tahoe:       "54fe0dfdd319660bf85263bd1d0b90cddd351b14d496197d4160138f295c1f4f"
    sha256 arm64_sequoia:     "046b721d1dff0759b4650d5ff68ad0d1c65ec0052555a3cd64b02ca24f8438dd"
    sha256 arm64_linux:       "6c3751cc1739028b4fc363a7cbea69b1eeed4b753c124d4a5e963dd59e3877c5"
    sha256 x86_64_linux:      "b3a1db40f6c6e377f537dcd05d7d13f67de1bdf984be1b4efcae3acdc4f66f85"
  end

  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "rust"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  allow_network_access! :test

  def anchor_workspace_toml
    <<~TOML
      [provider]
      cluster = "localnet"
      wallet = "~/.config/solana/id.json"

      [programs.localnet]
    TOML
  end

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli", features: "solana-v4")

    # TEMPORARY: anchor searches parents for `Anchor.toml` and the Linux sandbox denies listing `/`
    (buildpath/"Anchor.toml").write anchor_workspace_toml
    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/anchor --version")

    (testpath/"Anchor.toml").write anchor_workspace_toml
    (testpath/"Cargo.toml").write <<~TOML
      [workspace]
      members = []
      resolver = "2"
    TOML

    system bin/"anchor", "init", "--force", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
