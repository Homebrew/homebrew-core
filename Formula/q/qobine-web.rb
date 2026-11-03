class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-11-03-1.tar.gz"
  version "2026-11-03-1"
  sha256 "16e0e4da3b1e38af5bbab9e504a4af6774fc535016970f57690cd23753ef7745"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "576280a365c5bd9c2a395bcb8a04b7200eadcce20d7be06d80d9d63b1640c6ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "991d3bdc2a91b1aadb767874d5ae7e361d0a15a255b7a3afa2a32d52b9e9dd58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e89eccabf40fad6d89fe895763d6066df247ae24ada00d51a78f573b7953eb9"
    sha256 cellar: :any,                 arm64_linux:       "0d600054c9b52042e6835db2369595332ef0237f12549ccd00775359712f411b"
    sha256 cellar: :any,                 x86_64_linux:      "0ef8e566e83f8ddf79f023f3a758d2d13ae7f8b65209b8f1566314b3d61ca291"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("Login to Qobuz in browser...")
  end
end
