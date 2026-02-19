class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz"
  sha256 "f8c3486509de705192138b00ef2c00bbbdd0e84c30d5c07d23fc73a9dc4cc9cc"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0b80022fd0a04f16002086c6a3168fa26fee07367497a8a04c0bf7a64c9bdb3e"
    sha256 arm64_sequoia: "7e8b494be1a15604da1a57399a50a8873cfadb716cdcd87a8f0a82976fac1817"
    sha256 arm64_sonoma:  "b68a51be88cf60940d37dd9b5e2e384880ddf0543c01d932185527da26a9bf51"
    sha256 sonoma:        "54c280bd99458ce05f3c4fcdb48aab7cd38d313703f9ab01e9133a282a3e4bb4"
    sha256 arm64_linux:   "64941c4284c001b855fa8bb30c155ababc483c5a01937a7bb373ed45d2c32e4b"
    sha256 x86_64_linux:  "59dfbd75468a7271d44ed5f73284d1c8bdf934c257bcc3c9100efdc815b16724"
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
