class Aftman < Formula
  desc "Toolchain manager for Roblox, the prodigal sequel to Foreman"
  homepage "https://github.com/LPGhatguy/aftman"
  url "https://github.com/LPGhatguy/aftman/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f75aab63cb887c63e3888a225061a1ab4e0fd0d9c3e0a1c86b8ac7ad035fdf6c"
  license "MIT"
  revision 1
  head "https://github.com/LPGhatguy/aftman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0343817288ab09d6673a0cb3427b53d0c85d24cf1ea0be730c184a95715492c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350c4cddca8f5c18c6ba9b75e9cffbb649a82a14ab260791bcf3596ffff516c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6aab1ec5368a5109250ec6174836c4fc9bb1ee5cc69cc0b5f42b3b6d2591798"
    sha256 cellar: :any_skip_relocation, sonoma:        "1096045e74e9332ea2e144c92fa3ba290964d6e17296f64b1c206cbb4a5d6647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf831f645cdaa32eca888531a649f7456f46d29fa41f9a5ed28830ab873a3a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d16587bc51b9632792cfb31aa1f2fa3074bc932a9c7360c359b71f7d2afaf5"
  end

  # https://github.com/LPGhatguy/aftman?tab=readme-ov-file#%EF%B8%8F-aftman-is-no-longer-maintained-%EF%B8%8F
  deprecate! date: "2025-07-19", because: :repo_archived, replacement_formula: "mise"
  disable! date: "2026-07-19", because: :repo_archived, replacement_formula: "mise"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"aftman.toml").write <<~TOML
      [tools]
      rojo = "rojo-rbx/rojo@7.2.1"
    TOML

    system bin/"aftman", "install", "--no-trust-check"

    assert_path_exists testpath/".aftman"
  end
end
