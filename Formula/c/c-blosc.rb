class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/refs/tags/v1.21.7.tar.gz"
  sha256 "3c81252accfeeabd236fa219a8bf564c4feed9feb7a3291c227b03a00adb976f"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24db67e9fb0e885be0d0a7b7212df1050d4913f8ff02a6848033d8a47cabf390"
    sha256 cellar: :any, arm64_tahoe:       "8f3e601e99393d1929b14d52c6f68792c9feee477f490f989820a3d341b3624a"
    sha256 cellar: :any, arm64_sequoia:     "342b604169fa91f42f41682c3f9fa1b2dbff32dbc462f2435f5ec7d787ba63f6"
    sha256 cellar: :any, arm64_linux:       "df944abb0b9e6e0b3ce06096d794e17e0f11a1c5e25279e5e3fad5f8e918f81a"
    sha256 cellar: :any, x86_64_linux:      "c9625c53e286612f5347b87d17286f46b140623130e14e0fdcde4a80df6fafc5"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
