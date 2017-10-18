class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-10.4.0.tar.gz"
  sha256 "ed72cbfd8318d149ea9ec3a841fc5686f68d0f72e70602d59dd034cde43fab6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc9569041867dd7657d46515f7624fb469da2e07d02524a69ef70d4aa409ef2d" => :high_sierra
    sha256 "72c79a85c49ce2f21d8c051cf8fa89e51fbe5a433192ed0d1fcb3a351070a3cb" => :sierra
    sha256 "90ad337da72230a12d67e963656e28dd42af80d0410a0d1fb62c81db7ef9372d" => :el_capitan
    sha256 "a4688eec8932344ed3b399239271a1dbc0a4ee9df0ebec5413dded452e90a9ad" => :yosemite
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
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
