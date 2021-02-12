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
    sha256 cellar: :any, arm64_big_sur: "7c3247cd7c93ddab11db0c968e22a3c9b5b5c651fb44d9a2546236d48efea326"
    sha256 cellar: :any, big_sur:       "a2b0989ed5abeebd66746d77da454c85027431a85e972e5b183c6cbe4cdf1f29"
    sha256 cellar: :any, catalina:      "28c988129c2655e999bb7d33b2f38f33851e0d6236d00a5a102192fd336f8de7"
    sha256 cellar: :any, mojave:        "47fdd3970aac21938c82fd779bb668cd585e6b05f4f92590e13f6556520dbdd2"
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
