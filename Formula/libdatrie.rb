class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://linux.thai.net/~thep/datrie/datrie.html"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.13/libdatrie-0.2.13.tar.xz"
  sha256 "12231bb2be2581a7f0fb9904092d24b0ed2a271a16835071ed97bed65267f4be"
  license "LGPL-2.1-or-later"

  def install
    # 'make install' fails in parallel mode
    ENV.deparallelize

    args = std_configure_args
    args.delete("--disable-debug")

    # upstream ./configure does not support --disable-debug
    system "./configure", *args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <datrie/trie.h>
      int main() {
        AlphaMap *map = alpha_map_new();
        if (!map) {
          return 1;
        }
        Trie *test_trie = trie_new(map);
        if (!test_trie) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldatrie", "-o", "test"
    system "./test"
  end
end
