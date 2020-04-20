class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.6.1080.tar.gz"
  sha256 "61c4b1857bb80c67b06f83bbeb956275184e30e12401984587dfe79070218d3c"

  bottle do
    sha256 "148856828778ba5345ee0fe2c9b685d5965ec727271a5b71162e567c76cbf6f8" => :catalina
    sha256 "e24bdb6a19b9b42638fe804a0c2c8ebeab86c53a385d8c5a1750f18392160023" => :mojave
    sha256 "12c6536412f6a6f859075820409a32a08ec8071c68a8da189873a35546a71436" => :high_sierra
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
