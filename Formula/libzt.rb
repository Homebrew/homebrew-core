class Libzt < Formula
  desc "Encrypted P2P networking library for applications (GPLv3)"
  homepage "https://www.zerotier.com"
  url "https://github.com/zerotier/libzt.git",
      tag:      "1.3.3",
      revision: "a0b50530d37d9c13d30a68bf1d4686485be36327"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "42bc3dfa1a402b1306f51e56d07c9a79e5fa38c2c9aea11321a8bc6e8bdec66e"
    sha256 cellar: :any, big_sur:       "76fa124438f834a3396e103fcd6db122f8f3d45b04de27a7e422f6247367dcf8"
    sha256 cellar: :any, catalina:      "57fdc3d84cd81657411b579cb497aab00a1dd1b576d37947d30eb3f591997365"
    sha256 cellar: :any, mojave:        "253dc7f90329eae4b4d775cfd9c0e6647a971a54322a504b513b98e4b2c43038"
    sha256 cellar: :any, high_sierra:   "19554cc555c087797403049615b0145cec80dc3c49a5a70167b2fad75a0729ce"
  end

  disable! date: "2021-05-31", because: "has an incompatible license"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "make", "install"
    prefix.install "LICENSE.txt" => "LICENSE"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <ZeroTierSockets.h>
      int main()
      {
        return zts_socket(0,0,0) != -2;
      }
    EOS
    system ENV.cxx, "-v", "test.cpp", "-o", "test", "-L#{lib}", "-lzt"
    system "./test"
  end
end
