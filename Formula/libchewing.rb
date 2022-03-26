class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "http://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.5.1/libchewing-0.5.1.tar.bz2"
  sha256 "9708c63415fa6034435c0f38100e7d30d0e1bac927f67bec6dfeb3fef016172b"
  license "LGPL-2.1"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "1424757d5ef5bb08e8fe1949a9b53cf40af8aab8806b7dd22f2aa5e15d57d7ab"
    sha256 cellar: :any, big_sur:       "e1d6473e63dc121157f7afd61991b57335bac48f4d842262ac7c43e5b637b7eb"
    sha256 cellar: :any, catalina:      "19b9c38b3036f5ad16c413135e5424c8174789129cafe3c488fecdaffa39f281"
    sha256 cellar: :any, mojave:        "b00710a74c619461b99eb3043b927248ccc0e2c2f3607683dfbcad61b82e4fe3"
    sha256 cellar: :any, high_sierra:   "c346c2dbf72ea2d97f88cc9fc694b61eccc7db44c38092e9d652a31612f60ef1"
  end

  head do
    url "https://github.com/chewing/libchewing.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "texinfo" => :build
  uses_from_macos "sqlite"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <chewing/chewing.h>
      int main()
      {
          ChewingContext *ctx = chewing_new();
          chewing_handle_Default(ctx, 'x');
          chewing_handle_Default(ctx, 'm');
          chewing_handle_Default(ctx, '4');
          chewing_handle_Default(ctx, 't');
          chewing_handle_Default(ctx, '8');
          chewing_handle_Default(ctx, '6');
          chewing_handle_Enter(ctx);
          char *buf = chewing_commit_String(ctx);
          free(buf);
          chewing_delete(ctx);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end
