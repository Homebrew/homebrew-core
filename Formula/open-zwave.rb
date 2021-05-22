class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.6.1914.tar.gz"
  sha256 "c4e4eb643709eb73c30cc25cffc24e9e7b6d7c49bd97ee8986c309d168d9ad2f"
  license "LGPL-3.0"

  livecheck do
    url "http://old.openzwave.com/downloads/"
    regex(/href=.*?openzwave[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d7ac3272c8e97d579bd7cbf660d0831b282d426344d1c66d1d6273665972c5ac"
    sha256 big_sur:       "ca1c3e4e29bb19f377f169a015112818ebb69320ff76f05de671a857a28a4670"
    sha256 catalina:      "28b55791a9d9ab0a1c772e11ba7459d42b5e9cbed50d9e1db4af154b2ad84d5e"
    sha256 mojave:        "7e79dc03f657d9d92305f036d6118df60b56e2ddcbf8506234aa8b73dd9f4d31"
    sha256 high_sierra:   "e3bc4eeb04ec86a43d3a63f263db9aa28090123822de81869c44dcef4af08f8d"
  end

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    # The following is needed to bypass an issue that will not be fixed upstream
    ENV["pkgconfigdir"] = "#{lib}/pkgconfig"

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
                    "-L#{lib}", "-lopenzwave", "-o", "test"
    system "./test"
  end
end
