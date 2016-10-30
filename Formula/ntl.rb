class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.11.0.tar.gz"
  sha256 "379901709e6abfeaa1ca41fc36e0a746604cc608237c6629058505bfd8ed9cf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "caf7d8c05b1fc05f81720d7bb15dc6a6f35400f864e7127b1518375f1d4f6961" => :sierra
    sha256 "a5c752d7d68c7deb5579c65ab2c8e6d86cdd0f42a079b3b8dd18f543c2afe173" => :el_capitan
    sha256 "7e18d270ed1cd7e82b41e8b15a38c32feed36cf29d890fc1e18c836905dbfbd3" => :yosemite
    sha256 "e406e9a91f24abb86252fd652780c316f87e44fa13fb171e090a401a357b02a0" => :mavericks
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
    (testpath/"square.cc").write <<-EOS.undent
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
      -lgmp
      -lntl
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end
