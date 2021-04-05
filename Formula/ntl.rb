class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.4.4.tar.gz"
  sha256 "9d7f6e82e11a409f151c0de2deb08c0d763baf9834fddfd432bf3d218f8021db"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e3fdf3214220bd1c2bad264029df96c1b3e6e6abb73741e4e6cfa1492a79c96"
    sha256 cellar: :any, big_sur:       "01860b0c0190a6c5a1189ed0b1ab25c5ed06f8ac7025f3d50acccb6c1e134de6"
    sha256 cellar: :any, catalina:      "3a9dd95ffa5e4467467b0955d9b8eef9cf79a264ac1973f13c088b7cf21d5d93"
    sha256 cellar: :any, mojave:        "d0fc111707de1403ad34ad27ede466ac1f654287a96749e17398c3c4366a0cf5"
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
      -lpthread
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end
