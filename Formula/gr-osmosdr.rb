class GrOsmosdr < Formula
  desc "Osmocom GNU Radio Blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "https://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-0.1.4.tar.gz"
  mirror "https://github.com/osmocom/gr-osmosdr/archive/v0.1.4.tar.gz"
  sha256 "bcf9a9b1760e667c41a354e8cd41ef911d0929d5e4a18e0594ccb3320d735066"
  revision 4

  bottle do
    cellar :any
    sha256 "03ed53425d62f0c4bd012276f8de1f90bd893baed4c0e1ec459db758bb289de4" => :mojave
    sha256 "6af8dc42268c450c2b4621f478ab4345f8bd6735a3f7059dd5a7e380057c4aea" => :high_sierra
    sha256 "36f800b7f6795c07335f9506c5e5176d184f49979a9a6eeb95ffcb0c6fed0cc2" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "airspy"
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "hackrf"
  depends_on "librtlsdr"
  depends_on "python"
  depends_on "uhd"

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("Cheetah").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <osmosdr/device.h>
      int main() {
        osmosdr::device_t device();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lgnuradio-osmosdr", "-o", "test"
    system "./test"
  end
end
