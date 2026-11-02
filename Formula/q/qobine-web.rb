class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41c440f852535e032f7a2cbf51374f8987f51fee807a30c1e63cd9cd901c8f1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3540bafc96e0a702c174eae428d7519b4a74429af3b77bf301c4af0082885fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9719f080e1692c50833df840aacdf7e98014e5d92d82b40478e061dceba8ff02"
    sha256 cellar: :any,                 arm64_linux:       "1e6b881e2af1bad7dbf5d4a13d1b19b8df90108ccc0d1de711715d43936abb98"
    sha256 cellar: :any,                 x86_64_linux:      "280f1d351aa1da36d5d327a77d19cd91ce05a944ccedfec7a50fc366f90bb7f7"
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
