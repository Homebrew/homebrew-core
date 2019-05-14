class Libzt < Formula
  desc "Encrypted P2P networking library for applications (GPLv3)"
  homepage "https://www.zerotier.com"

  url "https://github.com/zerotier/libzt.git",
    :tag      => "1.3.1-hb1",
    :revision => "d5b064623e1161196fd5bc14668e83bec2c27717"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "make", "install"
    prefix.install "LICENSE.GPL-3" => "LICENSE"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <ZeroTier.h>
      int main()
      {
        return zts_socket(0,0,0) != -2;
      }
    EOS
    system ENV.cxx, "-v", "test.cpp", "-o", "test", "-L#{lib}", "-lzt"
    system "./test"
  end
end
