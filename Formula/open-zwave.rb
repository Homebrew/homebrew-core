class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.6.1914.tar.gz"
  sha256 "c4e4eb643709eb73c30cc25cffc24e9e7b6d7c49bd97ee8986c309d168d9ad2f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://old.openzwave.com/downloads/"
    regex(/href=.*?openzwave[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "46059e0f107fa894491dcca4afbc27487374077ac10d0c9e0466b70a21b98bdf"
    sha256 arm64_big_sur:  "946d78311179280c3460097a1b60331daa782d916b10e819b97fa80a06037c3f"
    sha256 monterey:       "510ea3942d2bac0c420ce6f096c55d00158cb9d68eef036e893bb66c135a4246"
    sha256 big_sur:        "e3c9055c54562fc0fc8879f094359263626bb0cbb0b67a1c48999420f2f223c4"
    sha256 catalina:       "af0ac45b4c07da453526cc464cf777d17cdbb3760c34ddefcfb3435977139d91"
    sha256 mojave:         "9680488853f6ee6db1f0e299ff1f00597e8652c095ecb411e322a99b8b43caad"
    sha256 x86_64_linux:   "32e72b176dcd28b5876df5dca595f9d9a93c159d475fbbe2affb9e21d6e1c30b"
  end

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    # The following is needed to bypass an issue that will not be fixed upstream
    ENV["pkgconfigdir"] = "#{lib}/pkgconfig"

    # Make sure library is installed in lib and not lib64 on Linux.
    inreplace "cpp/build/support.mk", "instlibdir.x86_64 = /lib64/", "instlibdir.x86_64 = /lib/"

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <functional>
      #include <openzwave/Manager.h>
      int main()
      {
        return OpenZWave::Manager::getVersionAsString().empty();
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/openzwave",
                    "-L#{lib}", "-lopenzwave", "-lpthread", "-o", "test"
    system "./test"
  end
end
