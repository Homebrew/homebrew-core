class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
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
    manifest_sha256 "e7f0207a7f95fb0a182bb47067dded16c340d231176b9d87748a8fd1510b46c3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9e6d01f3126e7d0675a9772402d3e4ae362512a443b310f1f93e198dc0bb093"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bda8f2f543d658b33a6a1ea45ce8591ab37316f29b824285173a1b758aacaa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9c56e8f7cbb17f62e78f6ff980f4c7224a5f524b6ed57b00e1da100661abd05"
    sha256 cellar: :any,                 arm64_linux:       "e562c5f955155adb170f71d415ea6e3fca5e02a93fdc0ab34fad2322d1663fd5"
    sha256 cellar: :any,                 x86_64_linux:      "6ec555343cc7845cd4424d13330c59bc07f6968548f3bff712f28cd394a97d62"
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
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("Login to Qobuz in browser...")
  end
end
