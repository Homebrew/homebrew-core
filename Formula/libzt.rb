class Libzt < Formula
  desc "Encrypted P2P networking library for applications (GPLv3)"
  homepage "https://www.zerotier.com"
  url "https://github.com/zerotier/libzt.git",
    :tag      => "1.3.3",
    :revision => "a0b50530d37d9c13d30a68bf1d4686485be36327"

  bottle do
    cellar :any
    sha256 "81e6e2709780349eb9d3c654e16a2dfa9b5f8f0e96e508c6ddc4d9e001df435d" => :catalina
    sha256 "1e677336f94b2d33bfc8050c571bd65b5091b2072ef17730831136948a8fb528" => :mojave
    sha256 "065371f5dc43376107afc6aa6e055ffd8c3d3bf22e034152205be5dcc30e527b" => :high_sierra
    sha256 "8fdc6bb393c91cc1807a1ac4e5758369b41716bdda353de87d7914806a28a64f" => :sierra
  end

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
