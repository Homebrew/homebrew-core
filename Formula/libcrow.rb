class Libcrow < Formula
  desc "C++ library for compact binary encoding of tabular data"
  homepage "https://github.com/packetzero/crow/"
  url "https://github.com/packetzero/crow/archive/v0.6.2.tar.gz"
  sha256 "4d06fd784a582015e8cb7f4c7e763a2ba203e9b7910061183b28484a5c7424f0"

  needs :cxx11

  bottle do
    cellar :any
  end

  head do
    url "https://github.com/packetzero/crow.git"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"tst.cpp").write <<~EOS
      #include <stdio.h>
      #include <crow.hpp>

      int main()
      {
        auto pEnc = crow::EncoderNew(1024);
        delete pEnc;

        return 0;
      }
    EOS

    flags = ["-L#{lib}", "-lcrow", "-I#{lib}/libcrow-#{version}/include"]
    system ENV.cc, "-o", "tst", "tst.cpp", "-std=c++11", "-lstdc++", *(flags + ENV.cflags.to_s.split)
    system "./tst"
  end
end
