class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.10.tar.xz"
  sha256 "6f6cdf7b8053f553b907e0c88a6064eb48cf2751852eb24323dcf027792334c8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "31de7c27443d4f477cfefa7b7598311b98b1998368385ea7a0787644c30a3c6f"
    sha256 arm64_big_sur:  "993a414772b41e1f0b2cffe21f9af240dbcd7e2b6de5d62a0e51b89a8144e40a"
    sha256 monterey:       "13a192f90ad01f376f5cbc977308d91bb096f3132ec41bea14a4b961866bfc1d"
    sha256 big_sur:        "1fd18afa48f013fcee08cadebf89c4bbb3e37444b591b16cd61e5848b93d6395"
    sha256 catalina:       "83d65ccf6e92620dd833dd23d1a02880f020ab24a0a6ed2ab5cb1a5149a32c5b"
    sha256 mojave:         "e48a5aea9d860765e58bcd756c8e81956974d4284189604755a63232fc13a806"
    sha256 high_sierra:    "8c9a8133c1fd1c554f995c089b12cbe049d2a8a01ac31cb5e68c089857a200a1"
    sha256 x86_64_linux:   "65f1e3cae4f56ec7264a6d59421564c75f10f65bae8ea3e3914dbb5e08fb7eee"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "perl" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    # this build uses the sqlite source code that comes with libgda,
    # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
    # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection",
                          "--enable-system-sqlite=no"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gda-sql", "-v"
  end
end
