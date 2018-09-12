class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.30.tar.xz"
  sha256 "e3fe0cb58b8a77f63fb1645c2f974b334f1614efdc834ec698ee7d861f1b12a3"
  revision 1

  bottle do
    rebuild 1
    sha256 "91d0a96cb5759db8de8d2fccce6be795cc671937adea732424376c76ff9ddd3b" => :mojave
    sha256 "74568bc0dcd4f4ad0408328ae49fb85ae3e93efcbefb649d43736e72f8c27a5e" => :high_sierra
    sha256 "0f155e4eaba3842210c76adeda3250c61f6819bfe108bfee429819c5c579b661" => :sierra
    sha256 "45b4d4d41251246e32f9ceea92faf205f8059fac4c37fd69f7da2b72fd8e8bcc" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 800
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  fails_with :clang do
    build 800
    cause "error: no matching constructor for initialization of 'value_type'"
  end

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    # Fix undefined symbols _COLORS, _COLS, etc.
    # Reported 21 Sep 2017 https://github.com/MusicPlayerDaemon/ncmpc/issues/6
    (buildpath/"ncurses.pc").write <<~EOS
      Name: ncurses
      Description: ncurses
      Version: 5.4
      Libs: -L/usr/lib -lncurses
      Cflags: -I#{sdk}/usr/include
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
