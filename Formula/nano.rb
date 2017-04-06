class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"

  stable do
    url "https://www.nano-editor.org/dist/v2.8/nano-2.8.0.tar.gz"
    sha256 "0b7b434805e5e343d2fef75804fc61c59323641d8c8e63d3027b4ac442689136"

    # Remove for > 2.8.0
    # Fix "error: use of undeclared identifier 'REG_ENHANCED'"
    # Upstream commit from 4 Apr 2017 https://git.savannah.gnu.org/cgit/nano.git/commit/?id=cc91ee603c24429375ace5d4b55d85c396668c2e
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/45f1329/nano/configure-ignore-reg-enhanced-test.diff"
      sha256 "20e988cd2406da8009c3f5f9ddde206d14e8586bd744bb7bf75326ba59eba653"
    end
  end

  bottle do
    sha256 "bb03075a4e5316ef7a072af10f9da696a715193e62fe47342bf8bc93afe98fd6" => :sierra
    sha256 "6076c3c886c11199a8eaa38635a07105373c9573cca280cbb4bb75f8162a3c78" => :el_capitan
    sha256 "1fb6916e77fee67076bb5a2b8b19370feb55cea031422df13cbd73073ba3446d" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
