class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-07-31.tar.gz"
  sha256 "702b0ceb99a4c5ceb702dc0ff79360d87e37a1ba5699b2af549d1be7649e80d2"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad9d8cb86366e09dfa83e0797640a805c03697873cc39b41e69c635c29340f36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f410d308d7071e835b585e0b7da56e3661bc80aee8b768dc3b515a21e2aeea4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8a8e75544fb5c1f570cc3e303db68c54c8167931bc2678437e0e56e4f234b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46fe80dd5fa2e50a02a1eec53d44916a149a5e7e0eb4226d1b78373f007ee1d"
    sha256 cellar: :any,                 arm64_linux:   "90584ec5e533a651d7973c4b86a9135044bb3c36585b2ebf6adc2c1068c7ce70"
    sha256 cellar: :any,                 x86_64_linux:  "f4d0663682b00d7a5e4b5029ecfe95eacdc3c4681edc902876aacfc50b62e9da"
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
