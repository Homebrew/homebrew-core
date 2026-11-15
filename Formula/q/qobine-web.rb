class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/SofusA/qobine/archive/refs/tags/v2026-11-13.tar.gz"
  sha256 "8f87b4d742487f625e897cd506a8e792f5840ccd113cb91743b6c89e7369ee1c"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b50a3daff9cc73842fa7a2f6ce1ad7c028a0c939e4a43b6a98e843e7c101c58f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aced61be0afe11e45d197931d8c01121d5863cb2376a8730f5dd86360ef4a604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "155203f245dfe1a9be50bc226ad8887fd9dda8a18a2b60e930953c66f30898e9"
    sha256 cellar: :any,                 arm64_linux:       "5f0558d6bc1fe97d1ce5c7e400cd83f3c48fce5356564c86854c92b0f5f1519a"
    sha256 cellar: :any,                 x86_64_linux:      "f9c33305e9613079d13df08ea01cfd23f781a1a655e719766d9f2615cafe58d4"
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
