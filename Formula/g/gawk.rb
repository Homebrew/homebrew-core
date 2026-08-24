class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gnu/gawk/gawk-5.4.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-5.4.1.tar.xz"
  sha256 "07f6f7342b7febe4313fc2c2542ad93d64fe20ad8717200109f105a826f5fd37"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "73633c61674c5ab754b70403f14eb57d21d750fe8629eecc8023d5e4228f26fe"
    sha256 arm64_sequoia: "299e407ee59def8e8cc48b0885c6d5ea453d3f886cc6edd2e6af781357f8d761"
    sha256 arm64_sonoma:  "b398c17f49d3e23c59d8b0d92a3603e15a1e1a2eef5418390ed2c07d888877a5"
    sha256 sonoma:        "17192ebb78bf9dea945724c11258b02ccdabf0f8833902d179f88ebab4491a4d"
    sha256 arm64_linux:   "ab274a83c365a24dc2f037bca65befc4c1aa1697d3b6bcc2f1bbd857d040db47"
    sha256 x86_64_linux:  "372c078e81e51049d9f5f15f4aad39b6f0a0c7b3c68d8c5fdbc7d6d81674358a"
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

    # case-check needs libc to fold ẞ (U+1E9E) to ß, which Sonoma lacks
    if OS.mac? && MacOS.version <= :sonoma
      inreplace "test/Makefile.in", "callparam case-check childin", "callparam childin"
    end

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
