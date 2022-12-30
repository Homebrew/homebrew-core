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
    sha256 arm64_ventura:  "75f5cc7303e2233b14c8d75c1bd030aedecb3805108246b7645b42e5716bd712"
    sha256 arm64_monterey: "0223f5e5d69c3b8ae50f9665e567e7f2462c947b74955b3d8fb7895d5d73c197"
    sha256 arm64_big_sur:  "7fd916fd9dc7f70c89ec1d280e5ffb0aec94e4a1329abca92a9b1c44b9b6e3c0"
    sha256 ventura:        "cb1d3cad74dcca71069e401acc140c51d4192803b073d97e230559acc31c1626"
    sha256 monterey:       "4c4b1b9becee9835568dc513ded2c4046a3f07a2a9c576ab04ff21a758e7e78b"
    sha256 big_sur:        "ba37e5dce0545e3c84d40c9610f1a4a633c4732fac6c8619a030d19b1b2070b5"
    sha256 catalina:       "ff65adfdd73bbfb3636a840ccf1a0c6a904f9779660836378f8719c46e27d184"
    sha256 x86_64_linux:   "00df3e9224a984613c28a32334007a7f3a9729fc4fc695cfb55855dcc4091d04"
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
