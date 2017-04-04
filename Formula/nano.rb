class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"

  stable do
    url "https://www.nano-editor.org/dist/v2.8/nano-2.8.0.tar.gz"
    sha256 "0b7b434805e5e343d2fef75804fc61c59323641d8c8e63d3027b4ac442689136"

    # Remove for > 2.8.0
    # Fix "error: use of undeclared identifier 'REG_ENHANCED'"
    # Upstream commit from 4 Apr 2017 http://git.savannah.gnu.org/cgit/nano.git/commit/?id=cc91ee603c24429375ace5d4b55d85c396668c2e
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/45f1329/nano/configure-ignore-reg-enhanced-test.diff"
      sha256 "20e988cd2406da8009c3f5f9ddde206d14e8586bd744bb7bf75326ba59eba653"
    end
  end

  bottle do
    sha256 "b9b7985beeaab3ab7ecb03d563c9aab3c4372ccf127ff26f78e8ce8f94ec41b3" => :sierra
    sha256 "cb4245a64555d0a869266d6106dbdf055a3e8b02a2b3be212beda99a2f310978" => :el_capitan
    sha256 "4fc26e6b0d647bf705a15c0d74aeb667ec70b2da177c7005b8a53c2da7c21b6d" => :yosemite
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
