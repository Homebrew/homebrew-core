class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-11-02.tar.gz"
  sha256 "cedfb0fa49aa35aa8c5274d3098b27ba4adc793bca243f6265967cf1335da4e6"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17035fccb9859979a4f8919ef0b852b8c0525b568507318940390901509715c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1228a804e6c8ad50d50517105e5d0b5b0335f18e5e4210dc47fb5172ba6efbdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe03b0afb9846fff6980e93b825a7e889820e09345c5ad00ef8abcadcec4253b"
    sha256 cellar: :any,                 arm64_linux:       "681256b3661803031015415f6d2740d9d15aca04149121e2495ed93d16c7ab57"
    sha256 cellar: :any,                 x86_64_linux:      "99cc1f358e59c3b67a9121fd17953ef9179120f86c21267ceed5d8cef1a0bbdb"
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
