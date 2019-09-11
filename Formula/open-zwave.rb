class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "https://github.com/OpenZWave/open-zwave/archive/v1.6.tar.gz"
  sha256 "3b11dffa7608359c8c848451863e0287e17f5f101aeee7c2e89b7dc16f87050b"

  bottle do
    sha256 "3558f07a0fc5c7fc44546e1a2cf7b51df88769d3d10e3d72861134ddb418bc07" => :mojave
    sha256 "2148dac1b2414919ee8dace92213b83d84aa329f42e32d0c5f2ca2304c91a70b" => :high_sierra
    sha256 "4804ba898c7c3527b7cbd7a0f7ce8d5358f00c96fe176f3365b6f25e5f5a2bdd" => :sierra
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
