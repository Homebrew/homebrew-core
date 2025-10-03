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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "81d0b47a818e674b72ddec4f61ab65989c8ed629d9804d58afb01a1d615a8c09"
    sha256 cellar: :any,                 arm64_sequoia:  "58f42ea3453634e3160598380eedb74e3917eec37fe55c5e57b09db4f4ca2314"
    sha256 cellar: :any,                 arm64_sonoma:   "ea1d6f7812b08ab488e3029479f886c293bec4ace34c3f6fa69dbce73823161e"
    sha256 cellar: :any,                 arm64_ventura:  "0a42ca8d1cb49fb7b8af53e5c62b6ebb327dee7d81555d58e3b47518ab2105af"
    sha256 cellar: :any,                 arm64_monterey: "23dde1c42eafdbba4fb7f2d5f26ae5115706fca6104de839903d1394e48a525d"
    sha256 cellar: :any,                 arm64_big_sur:  "6108f6abf3ec7cd2e4a3b1d3d36dce2cc59327b01d7168705cc1e6b6976c3976"
    sha256 cellar: :any,                 sonoma:         "72a33b48a02269658ea8ac820b621d6c4c3a6e3192a739ab816cac68dfd5d746"
    sha256 cellar: :any,                 ventura:        "5a5486d9e73641cafadebc2a16aaff3f0309fd88a03ecc6c51ab74aa9662ffd0"
    sha256 cellar: :any,                 monterey:       "85f1d652165756860f4f4c8ecc86e583ab9b58ec803804bf278a724319790c11"
    sha256 cellar: :any,                 big_sur:        "05b2e27723a47b64d46abb221ac931cbd4f530c2bea166ff4a75c6cc6aec496f"
    sha256 cellar: :any,                 catalina:       "e35e75d21d3414bf4586b7ca6ee2ff1f99b8fd7106bf32c7eec434b2de5135d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9537b4762ac42062b61e93b08eca2bbd875fcbf1a5defe17a6a83b192ce409e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804cfd8e327183c284a6018f22613896b1876aa2b5fffe99e7ecd594d6f4b006"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    # Rename VERSION file to avoid build failure: version:1:1: error: expected unqualified-id
    # Reported upstream at: https://sourceforge.net/p/itpp/bugs/262/
    mv "VERSION", "VERSION.txt"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
