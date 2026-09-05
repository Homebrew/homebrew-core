class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/otter-sec/anchor/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2b08bcb9b0dabb3ca4dfb24cd865f255fc7b5519d0b5c41063b8a8b89e16d58c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "14df7a7e7842f5d04697a6fc03b5165a557a20c2a7a1753b3703499d7c247b4e"
    sha256 arm64_sequoia: "c7626a179d30f39c07cce1e0d09a22d9ab9082edeaa5710a9a675f1db992ab85"
    sha256 arm64_sonoma:  "f141564e4868163a823e092bdb1a3ef89090699a8d0b4682c1dfe13767e7c7dd"
    sha256 arm64_linux:   "4725a7f018759fb80bb11be3eed94ab85124a04098d225f7820a6f9cd53307e9"
    sha256 x86_64_linux:  "58cc2fdbf9da4037ba125f3a804ce7dbe892b1023b828963186f617b9b0cd911"
  end

  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "rust"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def anchor_workspace_toml
    <<~TOML
      [provider]
      cluster = "localnet"
      wallet = "~/.config/solana/id.json"

      [programs.localnet]
    TOML
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # TEMPORARY: anchor searches parents for `Anchor.toml` and the Linux sandbox denies listing `/`
    (buildpath/"Anchor.toml").write anchor_workspace_toml
    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")

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
