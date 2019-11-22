class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.4.1.tar.gz"
  sha256 "a30687c4fbb8f114200426d2b1ece840bd024f64e2c5c6920b2d11ebcd82620e"

  bottle do
    cellar :any
    sha256 "0f45cad8f6ebe8fbadab18234e65f6314a5b2ed4c6849fc24ee368a90c250992" => :catalina
    sha256 "0c310592c48ec027fab85b05faa26d70f1e5353f43e92ef1ab8ee3ac71cff6bb" => :mojave
    sha256 "6fe920965e5de4a5a2c6fc702e5d5a8a4b9bb1123f10310416cf93680e3252cc" => :high_sierra
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
