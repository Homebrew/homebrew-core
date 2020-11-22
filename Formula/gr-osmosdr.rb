class GrOsmosdr < Formula
  include Language::Python::Virtualenv

  desc "Osmocom GNU Radio Blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "https://github.com/osmocom/gr-osmosdr/archive/v0.2.2.tar.gz"
  sha256 "5a7ce7afee38a56191b5d16cb4a91c92476729ff16ed09cbba5a3851ac619713"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 "c4a00d0ab33d277fbd036c7f496b09ca8259ec892a2a8877a3707a512f4ec705" => :big_sur
    sha256 "fe44d2d7c7191673e63737c5d836d678db4118c3642ac2bb8bb1a2ac9c9748c1" => :catalina
    sha256 "eda09b693472907745359cbc0f98bf8bb684d74d1cbca4d057683efa989a59aa" => :mojave
    sha256 "a7688b87b3100710348257944d22b23cadd98edd9fb06e145c8db1b80ad476a8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "airspy"
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "hackrf"
  depends_on "librtlsdr"
  depends_on "uhd"

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/50/d5/34b30f650e889d0d48e6ea9337f7dcd6045c828b9abaac71da26b6bdc543/Cheetah3-3.2.5.tar.gz"
    sha256 "ececc9ca7c58b9a86ce71eb95594c4619949e2a058d2a1af74c7ae8222515eb1"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")

    venv.pip_install resources

    system "cmake", ".", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
    system "make", "install"

    # Leave a pointer to our Python module directory where GNU Radio can find it
    site_packages = lib/"python#{xy}/site-packages"
    (etc/"gnuradio/plugins.d/gr-osmosdr.pth").write "#{site_packages}\n"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <osmosdr/device.h>
      int main() {
        osmosdr::device_t device;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgnuradio-osmosdr", "-o", "test"
    system "./test"

    # Make sure GNU Radio's Python can find our module
    (testpath/"testimport.py").write "import osmosdr\n"
    system Formula["gnuradio"].libexec/"venv/bin/python", testpath/"testimport.py"
  end
end
