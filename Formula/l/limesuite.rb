class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https://myriadrf.org/projects/software/lime-suite/"
  url "https://github.com/myriadrf/LimeSuite/archive/refs/tags/v23.11.0.tar.gz"
  sha256 "fd8a448b92bc5ee4012f0ba58785f3c7e0a4d342b24e26275318802dfe00eb33"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "412a1287101507e62517f810b903e5dfd619fd0ccac3c23c6fe5e8580221b0b1"
    sha256 cellar: :any,                 arm64_ventura: "26c22dc6a7143e5006e5d5ccf28ce807b5e77c4a66648aec9b7afc529c38f1ae"
    sha256 cellar: :any,                 sonoma:        "a0c8528c441e6f09eb54397549907bc5481fc96a24e3853683807e450111dc1f"
    sha256 cellar: :any,                 ventura:       "500ddb9fa793b9cf9b85945b0459e70199b1ece8afc9220bcd312e42b011d962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e7dc45e90a1e1237bc7f423548a8af0760fe61bb473469fea5de0ab5d4a624"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gnuplot"
  depends_on "libusb"
  depends_on "soapysdr"
  uses_from_macos "sqlite"

  def install
    args = %W[
      -DENABLE_OCTAVE=OFF
      -DENABLE_SOAPY_LMS7=ON
      -DENABLE_STREAM=ON
      -DENABLE_GUI=ON
      -DENABLE_DESKTOP=ON
      -DENABLE_LIME_UTIL=ON
      -DENABLE_QUICKTEST=ON
      -DENABLE_NOVENARF7=ON
      -DENABLE_MCU_TESTBENCH=OFF
      -DENABLE_API_DOXYGEN=OFF
      -DDOWNLOAD_IMAGES=TRUE
      -DLIME_SUITE_EXTVER=release
      -DLIME_SUITE_ROOT='#{HOMEBREW_PREFIX}'
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Checking driver 'lime'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=lime")
  end
end
