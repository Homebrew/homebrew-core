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
    sha256 cellar: :any, arm64_monterey: "3ac0f3c2f9faa033508319e8304d6bd625f204c611eb3e9a2b17546bfde5df42"
    sha256 cellar: :any, arm64_big_sur:  "58cdd18e870c3eac90a8cf734204245b8cc06485fd3bbd668ad9f23deec171d8"
    sha256 cellar: :any, monterey:       "ffc421190d8df527832f6c1fa14f7241e1a4b44b0bd3259583489298cb637630"
    sha256 cellar: :any, big_sur:        "23a47c6cba9cbb3e9a770bfcea731903fe4c80a75a2164584af2c41e6268e838"
    sha256 cellar: :any, catalina:       "aa0ca12987c52d39bae2885c4aed18aab6bbe2a4a1fa7d28fd04edbcdcfe4745"
    sha256               x86_64_linux:   "85023bee5a8507de34238665f02f68c7c43142d76b63d3337d515e1ffeb28a0b"
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
