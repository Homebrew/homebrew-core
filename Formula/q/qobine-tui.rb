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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d37f0e4aea7c16ded037790eb08cf182b82cf151222e95512dc03e38cab7c01e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac896d96993ce01827957c6e3eb93283b245c22c2163081a19481629c8a8665f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bbf89b9f3d4f4e6116847ffa856039b161771a297e4e11a5f1ec5e8d646c326"
    sha256 cellar: :any,                 arm64_linux:       "f609df04333ce8ef75b453bdbc0957e8041cfbd4d93c7722319fa77be1559b10"
    sha256 cellar: :any,                 x86_64_linux:      "207d7f7e64b6e7b24ee45ea7e9e4444193f14438b28287998fa7447f011541c1"
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
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
