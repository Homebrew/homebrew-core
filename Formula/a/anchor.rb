class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/otter-sec/anchor/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "2e4dd35104e003ef09890c35b29b45e1bf66f8f214dc749adbcecae9c0e467e2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "4f95eea51bf17a81c0d96e7fa277ed22be35f485bd6f4decd4a4c35a4b88e4e8"
    sha256 arm64_tahoe:       "d73080046f6cfa6f47ebc05dc9f386694647ead7977ded0b228872118c3daeff"
    sha256 arm64_sequoia:     "4fe59e203357472cf93e8745017c2161282b5116e3804c94d7bfaeb7682d49f8"
    sha256 arm64_linux:       "3eb818198d3a9234f2d8bfb01135000dedaa8db7505598632e0be0d5240445b5"
    sha256 x86_64_linux:      "09bb968a6d886515d9cfd5faf7e285ede2bf53cd154bb83f1c67c3993f7ce429"
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
