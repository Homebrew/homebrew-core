class Daktilo < Formula
  desc "Plays typewriter sounds every time you press a key"
  homepage "https://daktilo.cli.rs"
  url "https://github.com/orhun/daktilo/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "594987ad0697a29e3d0dc25b220e5680cfaecedf2175fd6c17ba827fc7bc2978"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ff1fd88a5f22968066a2fa40a1bf920755081c46b445c51fd1513efd7de2d59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08b93c796ccf69e6ad63d6a0109ddd3e497ba5dafcf0d050f818ea1ea4211b0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da61f9a129b3f86817d89889f0495546ab29e75c26aa4e0bfaf876cad604b19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546b3ee3d5da434c32614c51c92610ce80486b3685cc656c3228f1307c4188c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6934cd904014b23e31eff5febfd720868a370c85875a7662e8322e7e409aef"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e60d9deb2d00237f924690c9ad83c21fa0e9a39a2d5e21815b53d0a97e7a4aa"
    sha256 cellar: :any_skip_relocation, ventura:        "076a61558f93da37b2a31f97496fd4f687e578be0929488e931fbe3b806575fd"
    sha256 cellar: :any_skip_relocation, monterey:       "58cde688813e9da476cab1935487bbbaa337a781808602c6c34d3612e752a684"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "551661528d988f6e25e8723edb9b1d515d143178d237843da60fd52f946a5993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d862c33b912fb26fb8564fdc3bef5f666265f8945c9cd17c2b7fc030ee3e3ce7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxtst"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/daktilo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/daktilo --version")

    output = shell_output("#{bin}/daktilo -l")
    assert_match "kick.mp3,hat.mp3,snare.mp3,kick.mp3,hat.mp3,kick.mp3,snare.mp3,hat.mp3", output
  end
end
