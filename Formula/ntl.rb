class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.5.1.tar.gz"
  sha256 "210d06c31306cbc6eaf6814453c56c776d9d8e8df36d74eb306f6a523d1c6a8a"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c9b5f06bec63682e6e788b6461c5264e27d3e7deffc03c2d88260762c0d63511"
    sha256 cellar: :any, big_sur:       "ee75fde048ae49a67f69b0ac981fe9cfce8472ec5830291a00fce059ba6812c3"
    sha256 cellar: :any, catalina:      "173cce3de1f66c3991b87a29c331ba8ae69ed6805813e442cf1799521a34a5dc"
    sha256 cellar: :any, mojave:        "83f5353a1533bf632228c579e576bb5e4311c8716161edeab31a8d63b5ab06b7"
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
