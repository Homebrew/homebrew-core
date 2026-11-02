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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a6f5503f37880477283fd7e66d1ed584040854409b725a3156df4d5eec43d2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c286e2fbf270e880acf94eecb8d8474c56711fffa9a5e8815cca1981108ac87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad7faf15b988992709104f886b111695ac7e00628f1951b598e885b64376aab1"
    sha256 cellar: :any,                 arm64_linux:       "ce5a51f781f363570e386b5c1b76c25c951ae67a582465ea6c977372e2bcc86b"
    sha256 cellar: :any,                 x86_64_linux:      "33aafda69b329df8109080082ba1d16b91675fe5876ace260bebf24758696210"
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
