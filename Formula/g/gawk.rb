class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.3.0.tar.xz"
  sha256 "ca9c16d3d11d0ff8c69d79dc0b47267e1329a69b39b799895604ed447d3ca90b"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "73d743d915e4c9841f9bdc289710ef4ea071ccf1f026542f1fcc8ba4a870e8f5"
    sha256 arm64_ventura:  "36265210141086740f625d2e672b6275a2247de4de1f1df9747ed51b409a5e24"
    sha256 arm64_monterey: "24956ab7119678bf5168a66ace1b5e735cede929084ff756da14ab74a1c8f63a"
    sha256 sonoma:         "786aa0d52925e6816ece520d4ca45778862775249186e9bea85022dc96653c38"
    sha256 ventura:        "30185c073065bff4138f1512603315c789babcb83a3253a8155b670e4baa32c1"
    sha256 monterey:       "ee33b62eba04ca68cc6346b7fa51466696b9380f67e2a2bedaa367a1a154c9a4"
    sha256 x86_64_linux:   "2938d1181dc33bd3b5470f59eeda56184d522af135bcce84142d7495d1cf2b33"
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
    # Persistent memory allocator (PMA) is enabled by default. At the time of
    # writing, that would force an x86_64 executable on macOS arm64, because a
    # native ARM binary with such feature would not work. See:
    # https://git.savannah.gnu.org/cgit/gawk.git/tree/README_d/README.macosx?h=gawk-5.2.1#n1
    args << "--disable-pma" if OS.mac? && Hardware::CPU.arm?
    system "./configure", *args, *std_configure_args

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
