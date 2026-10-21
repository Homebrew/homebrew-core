class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-10-16.tar.gz"
  sha256 "826ddc36d1f297b7cd9da4fb542361eec5b321364378290a8c42c6b46ffb63cf"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46e3aafa6b14684e12f07b4c165fe42435cc19b6b6aeb4c55d2192d72ef62c1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c283782845c5e0c20c6dc37fe9b0a4685b9cc600b79afd26fcd937f300262f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3e000280e8f7def9c006c3c5a8920a7be77ab40ba3a5850b1b79f41d869cec8"
    sha256 cellar: :any,                 arm64_linux:       "7eb3aea1d1885c98340ca79cf1523f660bcf47a7c7d7980c86529bb7fb614b43"
    sha256 cellar: :any,                 x86_64_linux:      "e95c5519645182977e4fa32ef4604eb59f1e53f002e4f53a773152a77583babb"
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
