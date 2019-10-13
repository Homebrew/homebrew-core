class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.4.1.tar.gz"
  sha256 "a30687c4fbb8f114200426d2b1ece840bd024f64e2c5c6920b2d11ebcd82620e"

  bottle do
    cellar :any
    sha256 "d36287eff7d247b0ed8b9272c51cc0dabd486e4377a52791585ec6e088950319" => :mojave
    sha256 "42aa80db293b3831ac801bd63c3b16f79c90d42579aa4e2a2784c4068bea2a21" => :high_sierra
    sha256 "faadc525db2bd3df71037b4dbdc62cacad398d210659f84e00f34cf99287b398" => :sierra
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
