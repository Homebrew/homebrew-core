class Libgrapheme < Formula
  desc "Unicode string library"
  homepage "https://libs.suckless.org/libgrapheme/"
  url "https://dl.suckless.org/libgrapheme/libgrapheme-2.0.2.tar.gz"
  sha256 "a68bbddde76bd55ba5d64116ce5e42a13df045c81c0852de9ab60896aa143125"
  license "ISC"
  head "git://git.suckless.org/libgrapheme/", branch: "master"

  def install
    system "./configure"
    system "make", "PREFIX=#{prefix}", "LDCONFIG=", "install"
  end

  test do
    (testpath/"example.c").write <<~EOS
      #include <grapheme.h>

      int
      main(void)
      {
        return (grapheme_next_word_break_utf8("Hello World!", SIZE_MAX) != 5);
      }
    EOS
    system ENV.cc, "example.c", "-I#{include}", "-L#{lib}", "-lgrapheme", "-o", "example"
    system "./example"
  end
end
