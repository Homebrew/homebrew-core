class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.2.1.tar.xz"
  sha256 "673553b91f9e18cc5792ed51075df8d510c9040f550a6f74e09c9add243a7e4f"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "398affcca2ae34f356319c04675a1f9dac987fe93c24b7e44f3de0c3f2f80578"
    sha256 arm64_monterey: "9b5790b804bb252baff6d8fd36c72346b976ae6620d0a611da8dd259fe280937"
    sha256 arm64_big_sur:  "d36c8dde904dbc42ab10935b328bf5826a520df6f9116b6027d76bb6825480f7"
    sha256 ventura:        "3ac715c614601790fd8330232db1152ce43b7faf4360b86a6c4abd0fbd589042"
    sha256 monterey:       "5b8c20dceb9faf67e9527a55b80b1b6238f8f1dc43519c5cc1f8637bd2d5520b"
    sha256 big_sur:        "05e3e4bfe065797628bba4e0c5239cbd6392690259ff6f0eed0c58a1cd880422"
    sha256 x86_64_linux:   "cbf9ec54861af080e96532c8591ca2e9cf1347f3bcfdb7f70c92c1e35dcf2c48"
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
