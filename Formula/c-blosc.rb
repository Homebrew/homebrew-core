class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.3.tar.gz"
  sha256 "941016c4564bca662080bb01aea74f06630bd665e598c6f6967fd91b2e2e0bb6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8359fa0e10c950af14ab04d44330b611df21039eb5307f75af433eb15898b13"
    sha256 cellar: :any,                 arm64_monterey: "fde2c28b8a528ed0887842853158cd8ccd05329771d7440ff8a0a992c7fccfa9"
    sha256 cellar: :any,                 arm64_big_sur:  "dfdd5a19cc74e89a5f30adb6d4430d860521d7a2eb45fb54468e595eb5a6e72b"
    sha256 cellar: :any,                 ventura:        "f8ab242f7967734f6bf6eaa6d102f51051333c0bbcf5c77df0aabae85dfa4211"
    sha256 cellar: :any,                 monterey:       "8083af9c5079a08965a842e9eabfcc7ac315a0a7cb9042ae5a80e400a166003d"
    sha256 cellar: :any,                 big_sur:        "2514368ae6cd57100d29e8ab1f6101fb44f6f31d41ef9554cbfab906cedb53f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a413011db041f54ab8507953c11f6025b2a9e2141e42c2ad68290ad57c389a47"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
