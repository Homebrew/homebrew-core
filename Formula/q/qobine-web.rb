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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4fd31fdf53f8a72b995580035a42cd2b6165765ffb3c3262a7bc211169b4144"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bed886cfc9fdd33a78d2f161fa12939a10f7dfee2772e175c847e7647f3a9528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d0936e5d7ba61b49b020df668bf01b5acac1582752168a6f6085b2467e0cb03"
    sha256 cellar: :any,                 arm64_linux:       "0d298831324eda2a9016db3baae6985e5f3cdf457b17b825b208a09a1e05d9ed"
    sha256 cellar: :any,                 x86_64_linux:      "f31a47f7dbc872cee2fde0e689f3dc93786404b91021949e6a18590f24bc08a7"
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
