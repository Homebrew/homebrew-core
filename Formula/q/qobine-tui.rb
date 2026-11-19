class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/SofusA/qobine/archive/refs/tags/v2026-11-19.tar.gz"
  sha256 "27fb0556be885bc64f6384eca08ccb30b6b475116d45a54dffc570b83a8a20e0"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc4087d728bc4d689b1ddd34e36e16297d1013705f1c20b56c44a3b903a178fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8b1bef123fe6dd05f0431087e5de825b5ce3703546cf0f2b5727deb766d2723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0dbe8a7ea36db802c255bdd03734e4806b404b773e4ff20ebdf6b7337426a836"
    sha256 cellar: :any,                 arm64_linux:       "e332f383d0340a412bd4977253bbd821ec50824f52287b4f350a31c92f8243bd"
    sha256 cellar: :any,                 x86_64_linux:      "bcb86709e77e36cd3a43b49bd8a0fa3242eb1e43f61b2c760fe8d328eec5bc7d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
    depends_on "pipewire"
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
