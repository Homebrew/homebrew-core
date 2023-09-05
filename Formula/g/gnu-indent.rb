class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.13.tar.gz"
  sha256 "9e64634fc4ce6797b204bcb8897ce14fdd0ab48ca57696f78767c59cae578095"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "90269c7d0cb032e8defb0ed1a46222decdf12856f47206d7290aa42f41f64dc5"
    sha256 arm64_monterey: "ed32867a9b921557dcbd8eab24d0bd8045f6525d9000d0034fa9ed2a14e23a54"
    sha256 arm64_big_sur:  "e60464107020d08df53cf12dd388825cbeefd0d1ecf986f00cdf890d7cc58413"
    sha256 ventura:        "97399d01070ba20f588dde6cddf6a20353a1e2def99bd99d9f11d0d3c8f12748"
    sha256 monterey:       "ece97222820cb413acad02586561c87d8cda14370e6b4d0e2e5d47f5e7774402"
    sha256 big_sur:        "cf85276b497f4cf5e909ee415393207ad67c94bb9aa130e564f92f7b435d09a6"
    sha256 x86_64_linux:   "0e3f4a54c4abad7a07b57331772f24737237413f9ad4bd67ed8827909b515ced"
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
