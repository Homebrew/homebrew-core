class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.3.2/gtk-gnutella-1.3.2.tar.xz"
  sha256 "897d856e5f7dea35df6783372a6ae0d83306a9054f8cde25d6006e4f15e44dc4"
  license "GPL-2.0-or-later"

  # Track updates while deprecated. Remove if undeprecated.
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_golden_gate: "d261e6e17dec3840e816f620a0e91864b8df079a2599cfe37dbe175154683c69"
    sha256 arm64_tahoe:       "9582742005c1465ce216041c79f7f3eb78f165086c799ac49bc10e9b24c2c5fe"
    sha256 arm64_sequoia:     "a34532d9d85ce69bfc7a33a52cbfdf11a4e24c8dd1c0e46851ca3953bd56a7b3"
    sha256 arm64_linux:       "de510fd890c9afdcb5511cd2aff9e8b4ba141dfbaa9856813a4ad3f29134c34c"
    sha256 x86_64_linux:      "deb85b770fe557269375ca06ed6a98adf3aa52a11067ea782613ff30c36e8cf2"
  end

  deprecate! date: "2026-08-28", because: "needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "needs EOL `gtk+`"

  depends_on "pkgconf" => :build

  depends_on "at-spi2-core"
  depends_on "dbus"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work-around for build issue with Xcode 15.3: https://sourceforge.net/p/gtk-gnutella/bugs/583/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # FIXME: Xcode 27's clang lists `SDKSettings.json` first, so `dep.o:` and `dep.h` end up on different `-M` lines
    inreplace "Configure", '$contains "dep$_o:.*dep\.h" dep.out', '$contains "dep\.h" dep.out'

    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_r(share/"pixmaps")
    rm_r(share/"applications")
  end

  test do
    system bin/"gtk-gnutella", "--version"
  end
end
