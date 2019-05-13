class Libzt < Formula
  desc "Encrypted P2P networking library for applications (GPLv3)"
  homepage "https://www.zerotier.com"

  url "https://github.com/zerotier/libzt.git",
    :tag      => "1.3.1-hb0",
    :revision => "26ba6add126dd425c73627706753044e10b606af"

  depends_on "cmake" => :build

  def install
    system "git", "-C", "ext/lwip", "apply", "../lwip.patch"
    system "git", "-C", "ext/lwip-contrib", "apply", "../lwip-contrib.patch"
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
