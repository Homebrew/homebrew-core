class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1512fa5e84b9fd39cb8d8da7a5da0faa489ce0565a9614ca5e8082ef6abcfa3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57bdb2a3c3e980237f3ee32eb6dd244caf0f4eeb29f7191b18ded6068a90a4fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9596276f804a901851204f6ff83b729c21f92ef147d98f8bd59ab6c482e1a914"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad4721477988dc75a72913507245ad278bf879126ab3fdfda8e6a36a5517dbfe"
    sha256 cellar: :any,                 arm64_linux:   "d9f945f42f08b69986c05392e2795bd51512b027f1b64fa7318c39081d0ec87f"
    sha256 cellar: :any,                 x86_64_linux:  "5a6e98a656aaffd158393c11b2acabda6e394fbfdd7445dfd59c3ff5d6d0cea4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
