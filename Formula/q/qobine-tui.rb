class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-10-12.tar.gz"
  sha256 "8662611505a903300d6364fba5f4436d4ee5231639e49aa0095640420820669a"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95f2b453e98b89aaad2dc1dc0b8f70ea6fa99b7c28cdde21c351b5647f19d7ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7240cdf6c7c5d894c7c09883fe1cb988403fcb4f45350371947a06e57b735280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e727dbea14badae49d0ee7c81083bae3d0dd6837d8530128bb438e72b24850fc"
    sha256 cellar: :any,                 arm64_linux:       "12c201a72bb64f28104857670b6ecb3e153a5edd07ca6f452db5d08f38602da5"
    sha256 cellar: :any,                 x86_64_linux:      "febffa4ee1060c0f8d173e7168cca3af042b5244dc5d78972a687121ae8ca42d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
