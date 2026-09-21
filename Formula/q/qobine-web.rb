class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-08-28.tar.gz"
  sha256 "ef83834c13186964cae2935fe2d61d0f3a3c55b2a3bf7fe980a93576d62c299f"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd85a1502efa993815988e3ae5ed0d3ca5f1f2c85dc44f97c2bc055ee0174532"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "416691e38c2d92a8be7243285bd97aa31e9bd83f6d212b8ea771f2670390c41c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77b93c415e27691233320446940dcf4455ac3d909fa7cb8e3ff26fc22772ce5"
    sha256 cellar: :any,                 arm64_linux:       "e2b58edffb79aea1e556d7d9089efb04bf1424800a78e7b386afc238e0c01edc"
    sha256 cellar: :any,                 x86_64_linux:      "1c1e71af8624ebb5eca78973976676c3258d05a853588049608ae2d32a182dbe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
