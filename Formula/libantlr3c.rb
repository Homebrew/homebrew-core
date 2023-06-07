class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7265d5141b9b1115b4db096b40a131aa140fe4a6b2d97a08152d880665ed196"
    sha256 cellar: :any,                 arm64_monterey: "192faf2b2502946c3a8b27cade6a6febbd579de8fb1b9da136c48ea6a74bc621"
    sha256 cellar: :any,                 arm64_big_sur:  "0ba9d61434c3b1a05ef0ff9bb86e1e6d238c91723383204daeb5115976b05b02"
    sha256 cellar: :any,                 ventura:        "f83b901e8bbe67b933aecaf5d0db440b228d892c23e4917d2aaf7c1518b3c555"
    sha256 cellar: :any,                 monterey:       "8fa311163c90642a02332aebc6b4bd77d24fc2d0a45ecbc6f5670acb54e29977"
    sha256 cellar: :any,                 big_sur:        "3e442dfcc1083a693b77995703d2a2bb5100d13dfbae8cf174816fd112e90cb5"
    sha256 cellar: :any,                 catalina:       "53bc5810ecd6cc4be26da750839d53981ebba6ad931e13005661e599cfd69501"
    sha256 cellar: :any,                 mojave:         "c4df9f53203a7e21abc1fb22bf74256017f646e9177606c7da6c222db16dd3cb"
    sha256 cellar: :any,                 high_sierra:    "2de7942e4bc89830c0d92bfda55e60a4ad82723430bcc7477abb5d1b1ade7f86"
    sha256 cellar: :any,                 sierra:         "a5e779c431e16bdaab829c774468ce11f8e7ea359412800e294433b011704541"
    sha256 cellar: :any,                 el_capitan:     "fea1cde8ae732cdbbffa6a6d329239b1da067d2b69424d53178e60309748c403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd166cf59163343b31b229124ddf4e982c4fa42b196ec443b5ff8b02e12566a"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
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
