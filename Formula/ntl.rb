class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.4.3.tar.gz"
  sha256 "b7c1ccdc64840e6a24351eb4a1e68887d29974f03073a1941c906562c0b83ad2"

  bottle do
    cellar :any
    sha256 "fc44a358782565b05098a29f2694fe16100c2b5aa096c04875edd093adf78b5d" => :catalina
    sha256 "d0739cc2ebea1427d1fae3b0f871105b69d6f9c4c765415ed2f328af1e925598" => :mojave
    sha256 "5747add8bf85ae5a46d8c12635efbf61a2b5c402e35fdaebcf7499148c682564" => :high_sierra
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
