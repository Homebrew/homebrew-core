class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https://myriadrf.org/projects/software/lime-suite/"
  url "https://github.com/myriadrf/LimeSuite/archive/refs/tags/v23.11.0.tar.gz"
  sha256 "fd8a448b92bc5ee4012f0ba58785f3c7e0a4d342b24e26275318802dfe00eb33"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "c972a35fbb24b250b4b15f9dd07c44972997f32d365e1c740a0cf5bb63760725"
    sha256                               arm64_sequoia: "d9a62dcbd788fb2d607b563949f027d2c83a806dd6eede83c7e756c86d06c475"
    sha256 cellar: :any,                 arm64_sonoma:  "412a1287101507e62517f810b903e5dfd619fd0ccac3c23c6fe5e8580221b0b1"
    sha256 cellar: :any,                 arm64_ventura: "26c22dc6a7143e5006e5d5ccf28ce807b5e77c4a66648aec9b7afc529c38f1ae"
    sha256 cellar: :any,                 sonoma:        "a0c8528c441e6f09eb54397549907bc5481fc96a24e3853683807e450111dc1f"
    sha256 cellar: :any,                 ventura:       "500ddb9fa793b9cf9b85945b0459e70199b1ece8afc9220bcd312e42b011d962"
    sha256                               arm64_linux:   "bb64df9bb34063ff16d2f84e7e4b883f19e43e60b35c1edf47a763aaac6518a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e7dc45e90a1e1237bc7f423548a8af0760fe61bb473469fea5de0ab5d4a624"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gnuplot"
  depends_on "libusb"
  depends_on "soapysdr"
  uses_from_macos "sqlite"

  # Workaround for CMake 4 compatibility
  # PR ref: https://github.com/myriadrf/LimeSuite/pull/417
  patch do
    url "https://github.com/myriadrf/LimeSuite/commit/4e5ad459d50c922267a008e5cecb3efdbff31f09.patch?full_index=1"
    sha256 "7cfd2b80234771fc2de5660582f2003003a3c8c1b78337f0b41c4e367adcd266"
  end
  patch do
    url "https://github.com/myriadrf/LimeSuite/commit/698e416f9b9f1d0460508555c367124769cb3470.patch?full_index=1"
    sha256 "176a0a315fe65b2f8d848ce0d05e8eb3920127f18f1e1b6c11c2766a3a495be7"
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
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=lime")
  end
end
