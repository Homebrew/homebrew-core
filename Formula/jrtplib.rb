class Jrtplib < Formula
  desc "Fully featured C++ Library for RTP (Real-time Transport Protocol)"
  homepage "https://research.edm.uhasselt.be/jori/jrtplib"
  url "https://research.edm.uhasselt.be/jori/jrtplib/jrtplib-3.11.1.tar.bz2"
  sha256 "e24745f22418fb5d741b6b9871b89ed43964870f292dda92fd11cfbb5d6d0e43"

  bottle do
    cellar :any
    sha256 "9436c9b7df944ba95d9ec795b31fb728a49a39d4a764bfd86383e5dec4f726c9" => :mojave
    sha256 "afdd30606aacd4cb269b56a21176efcc3cff8f567bf43a48eedc0a54b9c9e4f1" => :high_sierra
    sha256 "8d57a4fbc612f51765e6dc13d47c695494e42f15584ebadc4b4042200e6061ee" => :sierra
    sha256 "1400bec305155882b16aa95fca1db8016011c2f9e39f4b1eb4ea28472072bacb" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jthread"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <jrtplib3/rtpsessionparams.h>
      using namespace jrtplib;
      int main() {
        RTPSessionParams sessionparams;
        sessionparams.SetOwnTimestampUnit(1.0/8000.0);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ljrtp",
                    "-o", "test"
    system "./test"
  end
end
