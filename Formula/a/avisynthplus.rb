class Avisynthplus < Formula
  desc "Improved version of the AviSynth frameserver"
  homepage "https://avs-plus.net"
  url "https://github.com/AviSynth/AviSynthPlus/archive/refs/tags/v3.7.6.tar.gz"
  sha256 "8c019a934189688e73fe1cd85e6768cc0bc120fe1f4a3310c889060283c9e083"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/AviSynth/AviSynthPlus.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "9f8926380d3e19a56eb2222e149e5383e8f670c428f9a34405b32ea39301db95"
    sha256 arm64_tahoe:       "41b2bc58ddf5cfbf87c78705239d3c660741fdb8dc50a91076939d4e0340aa7d"
    sha256 arm64_sequoia:     "69f00da4f099e889cca4d58a0f69344533332093b4061bca6b12534aa58114a5"
    sha256 arm64_linux:       "b494d3dc138aa1b7ef4c977b3aad34606fb5c7359b6d9523808f39511a3296e3"
    sha256 x86_64_linux:      "c3886160551d7752b811d0511a84368750e8c6872832a1e50215dfdf26124827"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "devil" # for ImageSeq plugin.
  depends_on "sound-touch" # for TimeStretch plugin.

  on_linux do
    depends_on "hicolor-icon-theme"
  end

  deny_network_access!

  def install
    # Preserve per-file SIMD flags for code selected by runtime CPU detection.
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <avisynth/avisynth.h>
      int main() {
        IScriptEnvironment* env = CreateScriptEnvironment(AVISYNTH_INTERFACE_VERSION);
        if (!env) return 1;

        env->DeleteScriptEnvironment();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lavisynth"
    system "./test"
  end
end
