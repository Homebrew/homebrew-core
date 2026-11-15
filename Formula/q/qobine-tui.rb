class QobineTui < Formula
  desc "Tui player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6aacb96833e40b2a8a46a091244e4ec3c863954bf51e795c929ac9bc2ab04aa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee067442a3756e9ceecb77b978d0a9baea71519928ccff38dee588376babcec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "991febc3879ba5b33af056128a4334a16a3a88b922f0841e6e2a8051a1dab896"
    sha256 cellar: :any,                 arm64_linux:       "47f36e823d64388e2b5441fcaa311c5363b0d380d3921dde2d0871904786b2e9"
    sha256 cellar: :any,                 x86_64_linux:      "3cd99f121c6d1d911d687877992deb8f2573ef250c0ad51e6ad2253403b84456"
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
