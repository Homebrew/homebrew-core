class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.3.2.tar.gz"
  sha256 "84ba3145abf8d5f3be6832a14c60b3368eb920719ee96e5774587e71ecd66e9d"

  bottle do
    cellar :any
    sha256 "499ee8006071fea07f6d6d8321fdb43ff13422b250a14b079fc6603c983cccba" => :mojave
    sha256 "e605a8e8d766ed861bbb53f8bc310f1fded4eeaecef5499de156c5992a98360c" => :high_sierra
    sha256 "48b5d4f40cec55c8782b8bd631d470739cf0e681f1abe6dec0772d7d870534ff" => :sierra
    sha256 "a9f60e9f64f1b8dd11519f3afbd9ff466a76e2410be9b9299cbc54527fea6203" => :el_capitan
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
