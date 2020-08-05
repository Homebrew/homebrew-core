class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.6.1080.tar.gz"
  sha256 "61c4b1857bb80c67b06f83bbeb956275184e30e12401984587dfe79070218d3c"

  bottle do
    sha256 "28b55791a9d9ab0a1c772e11ba7459d42b5e9cbed50d9e1db4af154b2ad84d5e" => :catalina
    sha256 "7e79dc03f657d9d92305f036d6118df60b56e2ddcbf8506234aa8b73dd9f4d31" => :mojave
    sha256 "e3bc4eeb04ec86a43d3a63f263db9aa28090123822de81869c44dcef4af08f8d" => :high_sierra
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
      #include <openzwave/Manager.h>
      int main()
      {
        return OpenZWave::Manager::getVersionAsString().empty();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/openzwave",
                    "-L#{lib}", "-lopenzwave", "-o", "test"
    system "./test"
  end
end
