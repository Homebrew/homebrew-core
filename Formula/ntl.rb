class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.3.3.tar.gz"
  sha256 "1bd9b64c3e8e8563b8f04e87851799dbfaa9d44d131c8531f66d390ca5b05b13"

  bottle do
    cellar :any
    sha256 "5a54ada102a07c107ff8b08f1995230cf977f6770552e16529dbb188f272ee11" => :mojave
    sha256 "0e55147c25186a9f5f5d22c47855570de07d7d5bd2eb1b9d4b0276b75dd31808" => :high_sierra
    sha256 "00c8d28ca2045a63753a751beeed1f6f63b198451cbda7b17096d03758cc3589" => :sierra
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
