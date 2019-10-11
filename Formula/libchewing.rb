class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "http://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.5.1/libchewing-0.5.1.tar.bz2"
  sha256 "9708c63415fa6034435c0f38100e7d30d0e1bac927f67bec6dfeb3fef016172b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "19b9c38b3036f5ad16c413135e5424c8174789129cafe3c488fecdaffa39f281" => :catalina
    sha256 "b00710a74c619461b99eb3043b927248ccc0e2c2f3607683dfbcad61b82e4fe3" => :mojave
    sha256 "c346c2dbf72ea2d97f88cc9fc694b61eccc7db44c38092e9d652a31612f60ef1" => :high_sierra
  end

  head do
    url "https://github.com/chewing/libchewing.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "texinfo" => :build

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
