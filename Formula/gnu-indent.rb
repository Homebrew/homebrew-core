class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.12.tar.gz"
  sha256 "e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "66cd2b91e533849daea9cfabbf525ddcc76d2086a8a8b4657e6fa236df2ab7d9"
    sha256 arm64_monterey: "2311fb51012e426bd4cf01047a98cbcf70a5bf343aa089dc706d1e3c84b05964"
    sha256 arm64_big_sur:  "bf082593202d39ea4c2929b333d544c72ef23d16fed04f570e1f4227098ebf6e"
    sha256 ventura:        "62ad5f27bb1a7676e87485f53b6d25635d5d3de0a76268b0dfaa66c82d6f2a0a"
    sha256 monterey:       "f23364d4a472c8c1430967e887da54e319bf94687cdeb718988dde87459691cd"
    sha256 big_sur:        "af4b5212440cdbb8c1c80bef3a13ca33bbdbd49918d24588af3a9eb44e484dab"
    sha256 catalina:       "82a12279be8834591a2104253ac562978b557c26b262dd8d5bfbf6e7b1103dd1"
    sha256 mojave:         "e960e3f35f6a77daef487f54158953522f58a27caf27e39e0c17702754718ee1"
    sha256 high_sierra:    "3280e6e9fc0c5cc895367291fc328dccae5f2e36606dd503b5721d449bc33eb8"
    sha256 sierra:         "98bcdee2e49d7e165a07ce6468d2c1a3030db7205472d015ba516e43f5a1e0fd"
    sha256 x86_64_linux:   "e3ef74b022310ffe3742480791e140ee05b61b315cfcb7de9fa6ebdac77a7b92"
  end

  depends_on "gettext"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gindent" => "indent"
      (libexec/"gnuman/man1").install_symlink man1/"gindent.1" => "indent.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "indent" has been installed as "gindent".
        If you need to use it as "indent", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    binary = if OS.mac?
      "#{bin}/gindent"
    else
      "#{bin}/indent"
    end
    system binary, "test.c"
    assert_equal File.read("test.c"), <<~EOS
      int
      main ()
      {
        return 0;
      }
    EOS
  end
end
