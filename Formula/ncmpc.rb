class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.46.tar.xz"
  sha256 "177f77cf09dd4ab914e8438be399cdd5d83c9aa992abc8d9abac006bb092934e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4eb2980aba45b5bf5fb6bf163339162bdac5ec8288ec6038c5d7f2943e86da6f"
    sha256 cellar: :any, arm64_big_sur:  "e8c3093bbf5a5a74509de958d6360d1d2f7f0b84644478fff6dcf99c00991e4e"
    sha256 cellar: :any, monterey:       "d7410a532844d96c9333e67ee2ffdb94d8b3cf8fb1e13fc410f9662ae8bee7e1"
    sha256 cellar: :any, big_sur:        "60305f8697125534ad15dc71be02288fb4a2c2d156889ab04f1eb9d5a3bc72f9"
    sha256 cellar: :any, catalina:       "b62c625ca3703f653837ffacbc98b4aa1a799ec39ce7992aae6a10d6da7bbb59"
    sha256               x86_64_linux:   "2b3dd68e87e15a8794481b7a442fefe80c44525985eb2a447af3c5de998813c1"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dcolors=false",
                                       "-Dnls=disabled",
                                       "-Dregex=enabled",
                                       ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
