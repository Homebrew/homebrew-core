class QobineTui < Formula
  desc "Tui player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "077bce3e8a977334e395209c9b3e71879c8ce8c2fe2c7bc6df82ce5c1ad1d912"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40c1becb31280ed1ffd698837a94321d36a1a7ba61e981f9866372102c396616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bab5c03517d8cc50a430c0dfdb907df94561c0ce6f349531c158de996761470"
    sha256 cellar: :any,                 arm64_linux:       "1c478d9475366b43532f865b7992c15bea9968e096c059f6e55c48e4eb738a58"
    sha256 cellar: :any,                 x86_64_linux:      "10da1dc60941fdfa4c772dd8c0df2d8702336065b0d58f553cbde7d009b20ca2"
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
