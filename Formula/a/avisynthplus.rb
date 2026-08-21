class Avisynthplus < Formula
  desc "Improved version of the AviSynth frameserver"
  homepage "https://avs-plus.net"
  url "https://github.com/AviSynth/AviSynthPlus/archive/refs/tags/v3.7.5.tar.gz"
  sha256 "2533fafe5b5a8eb9f14d84d89541252a5efd0839ef62b8ae98f40b9f34b3f3d5"
  license "GPL-2.0-or-later"
  head "https://github.com/AviSynth/AviSynthPlus.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8a80b4e719e788150160e0585e719b89f55c92f726d0250dfbf2390455207dbe"
    sha256 arm64_sequoia: "2c452d3b25bba973f1e8ff57d85af94489c177639f0e9eb1bc5f966622ec80d1"
    sha256 arm64_sonoma:  "0f17831e53889ceda0a5bf4878c14c3fb8896795a97ede0d09ea38f6e36cc1cb"
    sha256 sonoma:        "a5df0ec857a195ec9c86189880b58341b1a1a90fe1aa4401239171b4646eac84"
    sha256 arm64_linux:   "77b0a83a30fe2e3e1c3fc115d658fc9e9776fe70362f50ca27f33182704e8857"
    sha256 x86_64_linux:  "e8849de05a2acd980696ef8f508cbec84d0d9ca30c7499b8bf31005b827c8f0c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "devil" # for ImageSeq plugin.
  depends_on "sound-touch" # for TimeStretch plugin.

  on_linux do
    depends_on "hicolor-icon-theme"
  end

  def install
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
