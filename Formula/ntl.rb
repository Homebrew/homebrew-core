class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.2.1.tar.gz"
  sha256 "09918b8562654a0406afe13911ce37f5dc819e1852a67dec184a74ea70fd5b11"

  bottle do
    cellar :any
    sha256 "d2e3084101cb8ef628b9b0e11bbab6a3a336d67b06698981e654817a32d1c174" => :high_sierra
    sha256 "2f164dd67a76431e105faa20ceb75160104f88ddce4aa38b08f309e64ee71548" => :sierra
    sha256 "5f14dc4efcc0306c5b2293a56bb4222d7b7b2f8f101994975a05c797ca3f74b2" => :el_capitan
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
