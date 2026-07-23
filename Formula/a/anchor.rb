class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/otter-sec/anchor/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "7b10ee885486dc0b4fc9935c4d5bf861fd8662277ce89699207613582077881a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "56ddd8282cd7b4b842c04dcf7cb550ec437bc2d7fcb7cfe4f41ae308f1b7c0e5"
    sha256 arm64_sequoia: "d4bd1562dd5d94674668a13d93e8b11f25f3eba3f8f8258915fee146241ac9a5"
    sha256 arm64_sonoma:  "fdb1e38dc839f856d397b9214b2a6ec7f2eb97f05fd73a640be301223136c68f"
    sha256 sonoma:        "bd501ac94e31bc0057a2e6eb989a94877d3788ed4ececc744cfc8f344af2eb4e"
    sha256 arm64_linux:   "3f5b257f0afbe7789929b2b731d07d3cacea0d4837e5d1a8783b712ff86ea191"
    sha256 x86_64_linux:  "e8a6f1d8f9116b89165f95ad8f07fba99ad18a3368a65b3297d7a275a83e5e2e"
  end

  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "rust"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
