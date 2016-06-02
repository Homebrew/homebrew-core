class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "http://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.5.1/libchewing-0.5.1.tar.bz2"
  sha256 "9708c63415fa6034435c0f38100e7d30d0e1bac927f67bec6dfeb3fef016172b"

  head do
    url "https://github.com/chewing/libchewing.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "texinfo" => :build

  def install
    if build.head?
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
    system ENV.cc, "test.cpp", "-lchewing", "-o", "test"
    system "./test"
  end
end
