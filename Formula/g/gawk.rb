class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gnu/gawk/gawk-5.4.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-5.4.0.tar.xz"
  sha256 "3dd430f0cd3b4428c6c3f6afc021b9cd3c1f8c93f7a688dc268ca428a90b4ac1"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "e1bc77dcb48a44183688670a386ee6a3cd715eab698ee0b80ee31137315142f1"
    sha256 arm64_sequoia: "aa754b38ca8ca0faf881045cf942b830c133b1cea8070e0c236219e7833b347d"
    sha256 arm64_sonoma:  "34ef779d06ace9e63586abd8e2e8d8c53e4b2ee8127de6c6a85281d0c8bb8740"
    sha256 sonoma:        "5d049a18eed72add370ea73a187e7ee23521321f0b56a228eca4fb32b4e7704d"
    sha256 arm64_linux:   "7d360bbda03e7212c6c001dfbb9b6dc97fb0c2117f001e7dafffc119f1016c3c"
    sha256 x86_64_linux:  "299c7fbc71fe23b5c30380b6cc6419536183cd53769630bce5f86fc3311b586b"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    conflicts_with "awk", because: "both install an `awk` executable"
  end

  def install
    system "./bootstrap.sh" if build.head?

    args = %w[
      --disable-silent-rules
      --without-libsigsegv-prefix
    ]
    system "./configure", *args, *std_configure_args

    system "make"
    if which "cmp"
      # Cannot run pma tests in Docker container due to seccomp needed for personality syscall
      check_args = ["NEED_PMA="] if OS.linux?
      system "make", "check", *check_args
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (bin/"awk").unlink if OS.mac?
    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
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
