class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https://myriadrf.org/projects/software/lime-suite/"
  url "https://github.com/myriadrf/LimeSuite/archive/refs/tags/v23.11.0.tar.gz"
  sha256 "fd8a448b92bc5ee4012f0ba58785f3c7e0a4d342b24e26275318802dfe00eb33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "78cb49ea54e9921a5e702bd3069a0f73bf79657f639ad2b0121674e426dd1b10"
    sha256 cellar: :any,                 arm64_ventura:  "6dce8b71011151e03017734e3f7f88a94dbafc832eebdd68801db24313077af9"
    sha256 cellar: :any,                 arm64_monterey: "685348d490f4a7cfa4b101bcab50731d36d39138a12c184c4f16d19e3e5e150a"
    sha256 cellar: :any,                 sonoma:         "08851383efc2715115de48dae59b7822768b245307ead7dacb621ad57274c743"
    sha256 cellar: :any,                 ventura:        "921ee2dad497759f3b53e7333a9bca5d6768c735fcc786d6de769454d73c30d6"
    sha256 cellar: :any,                 monterey:       "5a852a175e341b887f4277e283b8848a0ae50d0e89667e7cbdd77118cbcb4a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0183d2b85edf613930c5e1560b02a15836efc40169e21cdbb950c7322144927a"
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
