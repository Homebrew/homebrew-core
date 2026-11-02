class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-11-02-2.tar.gz"
  version "2026-11-02-2"
  sha256 "019e18444e44d0831cfb7ef9ac0597c7cc7255aa2047cebb50a2a678e0257ca0"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aab1c15fa96ba81367596ee3fae1847c20f3ead4bb14b6f8293abc697e5b34b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b9d160c48589fcadae73d2482a12cde19c5466ad0bf73684ad286d8dbc0cf6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "072eb657af1e3ddce1bd99cc036f310bdf92ef8af9eb670b23df8308162420cc"
    sha256 cellar: :any,                 arm64_linux:       "8e1adf6afa87a8fe991deb664cfaac8e72af2d9cb256ddde1b870ad84d11e7e3"
    sha256 cellar: :any,                 x86_64_linux:      "a0cb270069de9bcca442142c0a1dfdee12e988adcdadaa9df2d68bb8015eea92"
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
