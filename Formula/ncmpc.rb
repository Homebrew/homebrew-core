class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.48.tar.xz"
  sha256 "b4b2d27e518096de2a145ef5ddf86cf46f8ba1f849bf45c6d81183a38869b90c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d972a5b7762fe82d28479c70396c5059a8f71d952839a365f76fc5e38624f611"
    sha256 arm64_monterey: "75dd544ffb559ceeea3e7aef066f3ee12486864c982617db2e04a549976f5ef9"
    sha256 arm64_big_sur:  "50707de0c5e3f299b813276238ffc657abdcde50e39af764775b7e375b9c5449"
    sha256 ventura:        "f10ff27801dfd881e27dbdc4907f6d215e7f57c7a550c377639451ec17bb4d2a"
    sha256 monterey:       "76ada885150f68be3c5d0c470416afdccb09cb8ba640e67b0207e95804a830c3"
    sha256 big_sur:        "cd991f46b58f4975b1ed32f7403e9d09bbc6062de9d6f266a329c0be829417c7"
    sha256 x86_64_linux:   "925a1263a32ebf02c6f23e886010b44e13158062d7ed1dadc13371b8b4350cd0"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre2"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dcolors=false", "-Dnls=enabled", "-Dregex=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
