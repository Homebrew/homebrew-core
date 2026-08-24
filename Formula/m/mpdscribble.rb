class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.26/mpdscribble-0.26.tar.xz"
  sha256 "b9d5829b89c465707256c140000e1a04b1d9d3afe50db46a843cf5ee54bf6309"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mpdscribble[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "458200a4d9cb5fa04ccf1f71264f72a8d96e47523201122d0be17a40b84ee5a1"
    sha256 arm64_sequoia: "9f5bbd434c0f8488dc1fff4aa04588ddf3686f34c7bbc38f9d41d5f7b89b3e29"
    sha256 arm64_sonoma:  "93332f33cb14b702f79f0c985f54e3dfa534d2a2f81945c72a6dde7803ecdc69"
    sha256 sonoma:        "8786cd0bc10ce5e7d9c05b6849b40715451c31ccc16214b00fe24f0f661fc6f1"
    sha256 arm64_linux:   "33135ad49568ed0711b8d91bc445ec0bc42f8c46cd374ff45d24de499246aa36"
    sha256 x86_64_linux:  "7296f3bf9fcc91040802140c6a2c4d5e9f2631e3ad26d346ddb5f3ecc5904011"
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
