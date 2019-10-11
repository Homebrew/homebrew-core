class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  revision 1

  bottle do
    cellar :any
    sha256 "53bc5810ecd6cc4be26da750839d53981ebba6ad931e13005661e599cfd69501" => :catalina
    sha256 "c4df9f53203a7e21abc1fb22bf74256017f646e9177606c7da6c222db16dd3cb" => :mojave
    sha256 "2de7942e4bc89830c0d92bfda55e60a4ad82723430bcc7477abb5d1b1ade7f86" => :high_sierra
    sha256 "a5e779c431e16bdaab829c774468ce11f8e7ea359412800e294433b011704541" => :sierra
    sha256 "fea1cde8ae732cdbbffa6a6d329239b1da067d2b69424d53178e60309748c403" => :el_capitan
    sha256 "8026d876b20980138c076cb4008f358deb858204b6399c436cf45e93594274e7" => :yosemite
    sha256 "010c3866a3c183b10dec76f845ce826a26a5a384074f8c56f41abeb9e4aa6e77" => :mavericks
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-antlrdebug",
            "--prefix=#{prefix}",
            "--enable-64bit"]
    system "./configure", *args

    inreplace "Makefile" do |s|
      cflags = s.get_make_var "CFLAGS"
      cflags = cflags << " -fexceptions"
      s.change_make_var! "CFLAGS", cflags
    end

    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-L#{lib}", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end
