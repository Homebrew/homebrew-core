class Jrtplib < Formula
  desc "Fully featured C++ Library for RTP (Real-time Transport Protocol)"
  homepage "https://research.edm.uhasselt.be/jori/jrtplib"
  url "https://research.edm.uhasselt.be/jori/jrtplib/jrtplib-3.11.2.tar.bz2"
  sha256 "2c01924c1f157fb1a4616af5b9fb140acea39ab42bfb28ac28d654741601b04c"
  license "MIT"

  livecheck do
    skip "No longer developed"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bcb22fe985a65c6e46980fa6837c761e266a0202076688362d846dcc48ff4a55"
    sha256 cellar: :any,                 arm64_sequoia:  "ef88fc08dc41b679c8ccdcaebabab8303f7eb30ccc8cddb2776e4952f335d2f0"
    sha256 cellar: :any,                 arm64_sonoma:   "c21691446176fd07d6163eece3a708d9088739e61fa29671cdeacdb3737fabc5"
    sha256 cellar: :any,                 arm64_ventura:  "82b8535c4b305e27653d742b771ba387c09e937be9917a8e53a8aa2c04034e2f"
    sha256 cellar: :any,                 arm64_monterey: "66a2c5923fb2f9999ea1a5adcacbceb38398231be4536f51f8902e4f84b5cdc4"
    sha256 cellar: :any,                 arm64_big_sur:  "b00a6b5d09b1eb5d8e6a72e548cff53f2834b4b07d235f3cb4ee346b9d4a0dbc"
    sha256 cellar: :any,                 sonoma:         "a6115879d309f486c2cccccd0564c24632a3393ad6b462892ee5e83ccef4479c"
    sha256 cellar: :any,                 ventura:        "86f675039a7b9e13b2da96de3f126ddc1cc0e4c6a9851bd4388663b194799d80"
    sha256 cellar: :any,                 monterey:       "f45e63073ae1de1f32605d885a92565dff5297205c875c27dfe36b270ca826b6"
    sha256 cellar: :any,                 big_sur:        "c025524ef889d74cc261768b9e12f8d3ffe57802adef254e2a01850db983e269"
    sha256 cellar: :any,                 catalina:       "05fc5e0747f7d5f725f9dda22cf39d414e8ee751829d14e9c32fa12279834cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5b43949d28bbbce5b86915445eafbd3bf25b40f38e8439487ccb3f7b54da00b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3a63a9f2e44c207522cb93a0bd93e429ed65937d74ea2b5d7a4110e46d9284"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jthread"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <jrtplib3/rtpsessionparams.h>
      using namespace jrtplib;
      int main() {
        RTPSessionParams sessionparams;
        sessionparams.SetOwnTimestampUnit(1.0/8000.0);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ljrtp",
                    "-o", "test"
    system "./test"
  end
end
