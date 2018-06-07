class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-11.1.0.tar.gz"
  sha256 "bb4ae214886f95a044ef16fdfd909f8d3181b288470ea7077c9f23d14047302f"

  bottle do
    cellar :any
    sha256 "dbb4938340e328c471a54b5babf2d0e1818578a27e26c50d3ae6a1575aafa02d" => :high_sierra
    sha256 "5a7cc515ed1f3f28b1a0fbd347066b04957cc80c316158b0c934d3bf9f0fcf8d" => :sierra
    sha256 "b2a8b90c9eafdad2a8774dba454e68de4b50776033630e0783d0f0d55abc20d7" => :el_capitan
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~EOS
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    EOS
    gmp = Formula["gmp"]
    flags = %W[
      -std=c++11
      -I#{include}
      -L#{gmp.opt_lib}
      -L#{lib}
      -lntl
      -lgmp
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end
