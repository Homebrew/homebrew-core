class Libzt < Formula
  desc "ZeroTier: libzt -- An encrypted P2P networking library for applications"
  homepage "https://www.zerotier.com"

  version "1.3.0"

  stable do
    url "https://github.com/zerotier/libzt.git", :branch => "master", :revision => "3d1159882117278fcb5fabb623bd62175b6c7e6c"
  end

  bottle do
    root_url "https://download.zerotier.com/dist/homebrew"
    cellar :any
    sha256 "e1ac8425fd0ea510c7db734af8d6c41cd3650b12f66a571f9d818c0121422eee" => :mojave
  end

  devel do
    version "1.3.1"
    url "https://github.com/zerotier/libzt.git", :branch => "dev"
  end

  head do
    url "https://github.com/zerotier/libzt.git"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build

  def install
    system "make", "update"
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "make", "install"
    cp "LICENSE.GPL-3", "#{prefix}/LICENSE"
  end

  def caveats
    <<~EOS
      Visit https://my.zerotier.com to create virtual networks and authorize devices.
      Visit https://www.zerotier.com/manual.shtml to learn more about how ZeroTier works.
      Visit https://github.com/zerotier/ZeroTierOne/tree/master/controller to learn how to run your own network controller (advanced).
    EOS
  end

  test do
    # Writes a simple test program to test.cpp which calls a library function. The expected output of this
    # function is -2. This test verifies the following:
    # - The library was installed correctly
    # - The library was linked correctly
    # - Library code executes successfully and sends the proper error code to the test program
    (testpath/"test.cpp").write <<-EOS
      #include<cstdlib>\n#include<ZeroTier.h>\nint main(){return zts_socket(0,0,0)!=-2;}
    EOS

    system ENV.cc, "-v", "test.cpp", "-o", "test", "-L#{lib}/Release", "-lzt"
    system "./test"
  end
end
