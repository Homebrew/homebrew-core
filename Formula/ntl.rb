class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.3.0.tar.gz"
  sha256 "3ae0d3647e5d52bc0907e1f4cb4a958460ee8e5b3c9862c1a4b8e9f0f75891dd"

  bottle do
    cellar :any
    sha256 "c1d81a0774d07793b8078beb494a7236e6305a0864f2f7e51860e5a936d41426" => :high_sierra
    sha256 "603dd46ff5554e9833b376be7cbc6aae0689cd224e40c25ca03ad4b1ecf1ba3f" => :sierra
    sha256 "0ae522bbd9a736d5456352a497ca8e9cbf3d0e6f81716405f47d6ba98d710c16" => :el_capitan
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
