class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.45.tar.xz"
  sha256 "17ff446447e002f2ed4342b7324263a830df7d76bcf177dce928f7d3a6f1f785"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "982287b4dcffb2e5534640b77f22b5f73865f8c0a521089252001557f3fe402a"
    sha256 cellar: :any, big_sur:       "212ca11a9b74741334dca03a195c1d46898d6d7036708d48cf3ef704f29ddde6"
    sha256 cellar: :any, catalina:      "6df55c912cf6f466378b548d9752793a9d2b6eb42c55c7cf2c1bc156fd29743c"
    sha256 cellar: :any, mojave:        "972c8c9f233312353c16e416ecdd8c643fb5d805946c5ca7cdd1e9fae8c792a7"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dcolors=false", "-Dnls=disabled", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
