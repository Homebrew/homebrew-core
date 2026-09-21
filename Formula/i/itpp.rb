class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "https://itpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/itpp/git.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/itpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "8c2ae9262836d4f5553998487dbbe29d17c8b0acfd4483336d027f5d9a0af6b5"
    sha256 cellar: :any, arm64_tahoe:       "060e7669b609986f0434b24e911a35fe23e6faecacee5e0de9bf56a53f742a6d"
    sha256 cellar: :any, arm64_sequoia:     "c899fd1589b28b54bb25bf0897374dcb094a36c966cf0c716e3326c3a7c13492"
    sha256 cellar: :any, arm64_linux:       "1bfcb53e3c421c99e71991b3f2209ad07a52416983cc41795ba90acfbb7dd5cb"
    sha256 cellar: :any, x86_64_linux:      "d6fb24604f7e7cd3ced740c5b23a0a582856ec4baac4f040d8d9f2ebcde23cec"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    # Rename VERSION file to avoid build failure: version:1:1: error: expected unqualified-id
    # Reported upstream at: https://sourceforge.net/p/itpp/bugs/262/
    mv "VERSION", "VERSION.txt"

    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    # Upstream only adds the OpenMP compile flags, so with `libomp` (via `fftw`) found the link fails on macOS
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_OpenMP=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <itpp/itcomm.h>
      #include <iostream>

      int main() {
        itpp::BPSK bpsk;
        itpp::bvec input_bits = "0 1 0 1";
        itpp::vec modulated_signal;
        bpsk.modulate_bits(input_bits, modulated_signal);
        std::cout << "Modulated signal: " << modulated_signal << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-litpp"
    system "./test"
  end
end
