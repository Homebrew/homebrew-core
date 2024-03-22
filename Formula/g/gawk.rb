class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.3.0.tar.xz"
  sha256 "ca9c16d3d11d0ff8c69d79dc0b47267e1329a69b39b799895604ed447d3ca90b"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "499846eee5d2c6b3be6fd9b7c6097728f935453741b9f148890fc05dfa46da77"
    sha256 arm64_ventura:  "8f10baab1fd634eba3b7f84edd353d9f978de2b11d20e76cb4294eb6fc963934"
    sha256 arm64_monterey: "f9885785f17b99fe4fdd3ed0df6c18835cd0d65d5cfa6f46b4eb193856a36495"
    sha256 sonoma:         "2b93e1aec7726e3276bcd4826b3f258c2bdad143ffcf6d36ea7b2b317fa3175e"
    sha256 ventura:        "d024c72187389da9f92ce7264dd199ab624fb0b25a210ce612705b5f8a1b9af5"
    sha256 monterey:       "1171dc2bb9c744ee48d96a379be108b80550daff5ed472512c16f73349ef9e50"
    sha256 x86_64_linux:   "a9c75546a0a9e37feed5cbe1512c3d1ff31f27349c5e63ed1934a60b2f25f576"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  on_linux do
    conflicts_with "awk", because: "both install an `awk` executable"
  end

  def install
    system "./bootstrap.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-libsigsegv-prefix
    ]
    # Persistent memory allocator (PMA) is enabled by default. At the time of
    # writing, that would force an x86_64 executable on macOS arm64, because a
    # native ARM binary with such feature would not work. See:
    # https://git.savannah.gnu.org/cgit/gawk.git/tree/README_d/README.macosx?h=gawk-5.2.1#n1
    args << "--disable-pma" if OS.mac? && Hardware::CPU.arm?
    system "./configure", *args

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (bin/"awk").unlink if OS.mac?
    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "awk" has been installed as "gawk".
        If you need to use it as "awk", you can add a "gnubin" directory
        to your PATH from your ~/.bashrc and/or ~/.zshrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
