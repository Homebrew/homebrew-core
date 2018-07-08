class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.2.0.tar.gz"
  sha256 "565d37b42ba4126aef7fc03cf2738dbe1ec46813e5488ebbebc7d249b00d62ee"

  bottle do
    cellar :any
    sha256 "1342da61b2eeae4cd4f3ff04e5bb3e98ff0335376f3a9ab5d13f1af6a3a77125" => :high_sierra
    sha256 "e4115a30760f6c39c25022a1f2568d1a4b06f506c2521e0040f574a33f0251ca" => :sierra
    sha256 "f7c263d242e36900f90c5b1d7e717285cdb47b6a8bd133845f422f34687fb9e5" => :el_capitan
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
