class GrOsmosdr < Formula
  include Language::Python::Virtualenv

  desc "Osmocom GNU Radio Blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "https://github.com/osmocom/gr-osmosdr/archive/v0.2.0.tar.gz"
  sha256 "9812429d97bc54f0a8917b880ca9e7e2421c66aeaac8ce5608161a8ae7007122"
  license "GPL-3.0"

  bottle do
    sha256 "75db466ce0d982bfd23dae1966bcd5ec847b2f54318dec6f3ed12ebc4f87ccdb" => :catalina
    sha256 "c94499d9a5921f56011cf5786ff8e81adc11106d307273901f3d13df6922683d" => :mojave
    sha256 "10c202c381db513e27868669165fd7fa603c8db68189aca7a14be954cb6796cf" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2/Cheetah3-3.2.4.tar.gz"
    sha256 "caabb9c22961a3413ac85cd1e5525ec9ca80daeba6555f4f60802b6c256e252b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
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
