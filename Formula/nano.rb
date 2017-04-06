class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  revision 1

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

    # Remove for > 2.8.0
    # Fix "Bad regex '[[:<:]]dnl.*': Invalid character class name"
    # Upstream commit from 3 Apr 2017 https://git.savannah.gnu.org/cgit/nano.git/patch/?id=8f2b5bbf3d1b23007aedc9f07f224da91f0ec479
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a03b730/nano/configure-fix-up-word-boundary-regex-logic.diff"
      sha256 "9f158ed8d6fa0276c7bcaea567b65acf883b95c2b7d374e6285b2aefb99669ed"
    end
  end

  bottle do
    sha256 "411a3a863a10702240e28408dda94d1b0982d914c0e180fd9c21907b9c505577" => :sierra
    sha256 "d35090367469708b482ecb2541fb6509376bdf3953bb7c7b5bcb7f25c7a1f34f" => :el_capitan
    sha256 "6bef87c38f8d3d04f94ebc2bdf9cce3c1eeb0492fca20c94ac007923fea3bbbb" => :yosemite
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
