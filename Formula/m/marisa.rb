class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https://github.com/s-yata/marisa-trie"
  url "https://github.com/s-yata/marisa-trie/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "1063a27c789e75afa2ee6f1716cc6a5486631dcfcb7f4d56d6485d2462e566de"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, "./test.cc", "-o", "test"
    assert_equal "200,100", shell_output("./test").strip
  end
end
