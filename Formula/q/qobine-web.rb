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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e10786de481cfd1c9ee6d12bbe9c97d9104f4e6414fc40793c9704ba72c67c96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6bc328531ece97e9c8f17af966c9f402e7f5f2889349ddb9881f514e5f1ba52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa4bdc75661807666dcb2ac55d28b842363b02fa5ab5eae5e36f68ccffdbb37a"
    sha256 cellar: :any,                 arm64_linux:       "882103e719a5e1c2783b2374f73ce6e856989d8b37df0ccfa68c4faf2a1ef3d3"
    sha256 cellar: :any,                 x86_64_linux:      "348f89fe9c56a4665293c412cef695cd4bf6ba6993a56741ca218e064467f6aa"
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
