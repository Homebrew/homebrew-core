class Aftman < Formula
  desc "Toolchain manager for Roblox, the prodigal sequel to Foreman"
  homepage "https://github.com/LPGhatguy/aftman"
  url "https://github.com/LPGhatguy/aftman/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f75aab63cb887c63e3888a225061a1ab4e0fd0d9c3e0a1c86b8ac7ad035fdf6c"
  license "MIT"
  head "https://github.com/LPGhatguy/aftman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e2b825b23c892fdf2a0067b011ccbfd4157006d27a5d5c115499331c0345c7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57feb860410d508174e62f9f07d467da9ca62c88b35005ea5ebcbed2ed87a71f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79678c381bbec86c92bee17e53dd01f34355e0dcda445f5a90a1d287c4825c11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f52a939e6d2cefc3d5e936a08ef2450b8bb0ad909af7f71adc0c1ec7bb1cfc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3302f69a40b249f7cfa486fa479674c4373c4666e815b07042bc829e151c371e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdf56dee4a49f7c3e0038b48b7dc2520dc94882bc7a2e5ce554bc4cc89ce2c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "707ab252c150e4208055d2398d6d7bf29ca1309d329128a2f3303ba45011717c"
    sha256 cellar: :any_skip_relocation, monterey:       "9afea6436f083ac4beca2dd9e1321490a7768a5f0f784a0fcacd6f7a813c32a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d9457a79cb80b1423563f8d54ffcf84e2b765189b526f029437841c2f2abe335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8943e04ce29ca295996d3acacb141d87504a59374aa2da2e7e15a453bbe5a9"
  end

  # https://github.com/LPGhatguy/aftman?tab=readme-ov-file#%EF%B8%8F-aftman-is-no-longer-maintained-%EF%B8%8F
  deprecate! date: "2025-07-19", because: :repo_archived, replacement_formula: "mise"
  disable! date: "2026-07-19", because: :repo_archived, replacement_formula: "mise"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
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
