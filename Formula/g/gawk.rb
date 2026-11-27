class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gawk/gawk-5.4.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-5.4.2.tar.xz"
  sha256 "b95e4909533b5f988c6b5e5539b3b3ddf76e7d7df02ca2e5b5b7d6f62db78e6a"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    manifest_sha256 "e6866e60bdeac36df0fa9e3263a16dc9acf9f0d65e09f2031cc0985838d48bd7"
    sha256 arm64_golden_gate: "0a94ede15d069d023cd4f20d27553b8f8684e9ab44e7465686a5f94c3005b9b7"
    sha256 arm64_tahoe:       "935d146fe6c6da7c4b1d33ab7b9801dc8deb5d176e828436a84e7646bf8f70fe"
    sha256 arm64_sequoia:     "25cc590e0c007f8cd1b5776bfdd1fe336c4aec347bae63152bb5756d52ce3bfc"
    sha256 arm64_linux:       "9487ee062c40c01b54e699d13be30398d2a3772bf3692cfeee149a106b4a3c7f"
    sha256 x86_64_linux:      "74c368417239487510bbe5ff89e6769dbcf4d11ac0ba1681492769bebed4c6e8"
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

  deny_network_access!

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
