class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.2.2.tar.xz"
  sha256 "3c1fce1446b4cbee1cd273bd7ec64bc87d89f61537471cd3e05e33a965a250e9"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7d7710fa6bdd0e3cdbb29c0a9492ffaa94a0536b02b328ecdb88bf0190467331"
    sha256 arm64_ventura:  "65f1eef20c9020d64d6e664d556d3b55cba583c3e64986dff74833176de62129"
    sha256 arm64_monterey: "6a22d40e0864a6bd67522c0c1ebcefb92a08d4370ca11f47fd505c6cc26a58c7"
    sha256 arm64_big_sur:  "3d7e64fc455d1cb077101b6be42ae8e4e595a94a2325eb14f4b2278f6dd05009"
    sha256 sonoma:         "3c6908020ad430acece358dd67711d95ff1f62567466c63f0d59ba1b89d7375d"
    sha256 ventura:        "aff1e481cdfb6f23d99e951a3b3b7efcb628141856666eb5d70d824125959031"
    sha256 monterey:       "36a97b5d58be2e0f4c59dd0a408d6508e13ebad9ca83c72e60ce9a94cc2d2d1b"
    sha256 big_sur:        "dac1bf3984e01fe1dd3ed03ecb98116eeaaf631a2a15d9417b55c4e8dd7a8e73"
    sha256 x86_64_linux:   "5dff4bf12d6526e57e13d81cdc9fd5273d0c52a83418fefa5411e4a50634fa20"
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
