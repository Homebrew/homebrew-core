class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "5f459ad90cd007c30aaefb7d122bba2a4307ea02915c56381be4b331cca92545"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  depends_on "gcc" => :build

  def install
    system "make", "all", "PLIBS=libsais.a"
    system "make", "install", "PREFIX=#{prefix}", "MANS=#{man}", "PLIBS=libsais.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsais"
    system "./test"
  end
end
