class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://github.com/tlwg/libdatrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.13/libdatrie-0.2.13.tar.xz"
  sha256 "12231bb2be2581a7f0fb9904092d24b0ed2a271a16835071ed97bed65267f4be"
  license "LGPL-2.1"
  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--enable-shared"
    system "make"
    system "make", "install-exec"
    system "make", "install-data", "INSTALL_DATA_HOOKS="
  end

  test do
    # Test that the library can be linked and basic functionality works
    (testpath/"test.c").write <<~EOS
      #include <datrie/trie.h>
      #include <stdio.h>
      int main() {
        Trie *trie = trie_new_from_file("/dev/null");
        if (trie == NULL) {
          printf("trie_new_from_file works (expected to fail with /dev/null)\\n");
          return 0;
        }
        return 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldatrie", "-o", "test"
    system "./test"

    # Test the trietool binary
    assert_path_exists bin/"trietool"
    assert_path_exists bin/"trietool-0.2"
  end
end
