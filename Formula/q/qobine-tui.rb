class QobineTui < Formula
  desc "Tui player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17d21ab302640a38d4ef8934ca261dfc743d3dd5d46040080b6359b695c8285b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2de375fa7657ffdf9a6b2f90e5222f65eb3548523109aa5642e8b6ebb1d103f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ba0c590bd273b64c2bca9c108a5073d36f67a9761cecd6595be4227b30f0c8b"
    sha256 cellar: :any,                 arm64_linux:       "3eafad1248e7cda07a19d240bf362d8f068c90425f6138583413b2d1a7addc45"
    sha256 cellar: :any,                 x86_64_linux:      "44dc4fb5f53b5d6db8961458eb4059f6b16f42612b20d151bdfdde4e4a5aaa7a"
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
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
