class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.27/mpdscribble-0.27.tar.xz"
  sha256 "f87aff9720c8a33ced436995bbe05543b54c97d2b8d3e08594d39a0693936d7a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mpdscribble[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "1fb4e82b6ab89f487029e3a7021231082a8060a4cdb1bdabe7a4e76645a3a614"
    sha256               arm64_golden_gate: "88b7c10829cca702da48be5d53b7c4b1de3d7a7accd2c8a86079f3f31897463a"
    sha256               arm64_tahoe:       "f5d513fbced330897a6071269a3274af9e0ac4f1489e1a48094ab7c68441f5e2"
    sha256               arm64_sequoia:     "f77fe7d7a5a0b821956e2f530a99c27678a7cee78e76a0985f59615ae27837bd"
    sha256               arm64_linux:       "a27c1a0b49120533ebfcf94c883358a29eede54e26be672c27ac94036fd02b73"
    sha256 cellar: :any, x86_64_linux:      "2181bb82876c760e79c0e1299c9917d2f6e44f06e9ddb4940d83f46e75f85c1e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fmt"
  depends_on "libgcrypt"
  depends_on "libmpdclient"

  uses_from_macos "curl"

  def install
    system "meson", "setup", "build", "--sysconfdir=#{etc}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      The configuration file has been placed in #{etc}/mpdscribble.conf.
    EOS
  end

  service do
    run [opt_bin/"mpdscribble", "--no-daemon"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "No 'username'", shell_output("#{bin}/mpdscribble --no-daemon 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mpdscribble --version")
  end
end
