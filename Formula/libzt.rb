class Libzt < Formula
  desc "ZeroTier: libzt -- An encrypted P2P networking library for applications"
  homepage "https://www.zerotier.com"

  url "https://github.com/zerotier/libzt.git",
  :tag      => "1.3.0",
  :revision => "2a377146d6124bb004b9aa263c47f7df2366e7ea"

  depends_on "cmake" => :build
  depends_on "make" => :build

  def install
    system "make", "update"
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "make", "install"
    cp "LICENSE.GPL-3", "#{prefix}/LICENSE"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include<cstdlib>
      #include<ZeroTier.h>
      int main(){return zts_socket(0,0,0)!=-2;}
    EOS

    system ENV.cc, "-v", "test.cpp", "-o", "test", "-L#{lib}/Release", "-lzt"
    system "./test"
  end
end
