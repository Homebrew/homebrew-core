class AcesContainer < Formula
  desc "Reference implementation of SMPTE ST2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.2.tar.gz"
  sha256 "cbbba395d2425251263e4ae05c4829319a3e399a0aee70df2eb9efb6a8afdbae"

  bottle do
    cellar :any
    sha256 "26cfdcca70d0fb62834376bfbda89af0acd57f0173a4a3c9bd0f77adf748c8b9" => :catalina
    sha256 "5f2c4a76a3a1082e3d969143455c8a47b8d05d7251424b7e8d821b4e73f46a9e" => :mojave
    sha256 "4297afa069f1cd305e93038ed43260b3643f0bd27f39e33355061fc111fb7f6f" => :high_sierra
    sha256 "6b276491297d4052538bd2fd22d5129389f27d90a98f831987236a5b90511b98" => :sierra
    sha256 "16cf230afdfcb6306c208d169549cf8773c831c8653d2c852315a048960d7e72" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "aces/aces_Writer.h"

      int main()
      {
          aces_Writer x;
          return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lacescontainer", "test.cpp", "-o", "test"
    system "./test"
  end
end
