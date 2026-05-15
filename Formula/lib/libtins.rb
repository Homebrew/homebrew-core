class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/refs/tags/v4.5.tar.gz"
  sha256 "6ff5fe1ada10daef8538743dccb9c9b3e19d05d028ffdc24838e62ff3fc55841"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "38159a186f5cfc1814d2213988961c0722fa0516c3e3e358cce144ca75deeb9b"
    sha256 cellar: :any,                 arm64_sequoia: "90d59f1f6bfbae9ed0df679f1d5b01e5fbf0250a06952bea0569c730ef91308f"
    sha256 cellar: :any,                 arm64_sonoma:  "3453d410232d79ff731aa368d989f39330673f81dd4c8bd0c639d0a3d3edd256"
    sha256 cellar: :any,                 sonoma:        "38e9b99edfe1ecc2fc1fd4b631d23003d68c9328c27af7562e0882caced2a0bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce171f76d72665a789898ef1699e48c13fa8006b3ccd3c2a54d8fd6f9c843b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcbd72e7f1c30f197318654896be2ad81b9d16f910ec1cde31a264c8a850a7d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "libpcap"

  def install
    args = %w[
      -DLIBTINS_BUILD_EXAMPLES=OFF
      -DLIBTINS_BUILD_TESTS=OFF
      -DLIBTINS_ENABLE_CXX11=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
