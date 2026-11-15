class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https://myriadrf.org/projects/software/lime-suite/"
  url "https://github.com/myriadrf/LimeSuite/archive/refs/tags/v23.11.0.tar.gz"
  sha256 "fd8a448b92bc5ee4012f0ba58785f3c7e0a4d342b24e26275318802dfe00eb33"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256               arm64_golden_gate: "3d2aaa62850e225ca4276e6e8b8409c12f3a18d840351921f8c935ea55be3fa9"
    sha256               arm64_tahoe:       "1f55b0467487856cc6f361175475b77ecd76d43635c1253d41fb80492da5d9ca"
    sha256               arm64_sequoia:     "3bc0c8e31ee9a982b32d9174b418fd8ee70bd7ea33d70db385295a6a5fcf2bfc"
    sha256               arm64_linux:       "92642dc8f77df042b5568787604f339414f917db479cb842ec948a75b86c52b1"
    sha256 cellar: :any, x86_64_linux:      "79dad8c545ced9451d6572a38ab4c720c4741efd247046a3c7cfb0557a7c2d8a"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gnuplot"
  depends_on "libusb"
  depends_on "soapysdr"
  uses_from_macos "sqlite"

  # Workaround for CMake 4 compatibility
  patch do
    url "https://github.com/myriadrf/LimeSuite/commit/4e5ad459d50c922267a008e5cecb3efdbff31f09.patch?full_index=1"
    sha256 "7cfd2b80234771fc2de5660582f2003003a3c8c1b78337f0b41c4e367adcd266"
    type :backport
    resolves "https://github.com/myriadrf/LimeSuite/pull/417"
  end
  patch do
    url "https://github.com/myriadrf/LimeSuite/commit/698e416f9b9f1d0460508555c367124769cb3470.patch?full_index=1"
    sha256 "176a0a315fe65b2f8d848ce0d05e8eb3920127f18f1e1b6c11c2766a3a495be7"
    type :backport
    resolves "https://github.com/myriadrf/LimeSuite/pull/417"
  end

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
                 shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=lime")
  end
end
