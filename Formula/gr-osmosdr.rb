class GrOsmosdr < Formula
  include Language::Python::Virtualenv

  desc "Osmocom GNU Radio Blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "https://github.com/osmocom/gr-osmosdr/archive/v0.2.0.tar.gz"
  sha256 "9812429d97bc54f0a8917b880ca9e7e2421c66aeaac8ce5608161a8ae7007122"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 "bc0e94a1514d228e6eb6868abc8aeaa56c1bb8c65c3e3afe68cdc2055381e65f" => :catalina
    sha256 "da85067073251ba9bcb88d0047cc77b898e31762f9b3d423cbc2686e9bb5f9d7" => :mojave
    sha256 "f973fe7465ea4931cb31096a1b26fdef355403b38dd01dfd236aa2eb4e18b182" => :high_sierra
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

  # Fix for Boost 1.73.0
  # https://github.com/osmocom/gr-osmosdr/pull/19
  patch do
    url "https://github.com/osmocom/gr-osmosdr/commit/5646d55f4f8b47b4602dad60d24385e393a47f61.patch?full_index=1"
    sha256 "2cc914dc1aea0e2258e2642c1173c6d11173bf64b1221af7cab9ceebd5f3f517"
  end

  def install
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")

    venv.pip_install resources

    system "cmake", ".", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
    system "make", "install"
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
  end
end
