class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.14.tar.gz"
  sha256 "83104e4f7e28b02f8bf6b010d69b626fae591f887e949816305daebae527c9a5"
  license "GPL-2.0-or-later"
  head "https://github.com/LibVNC/libvncserver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^LibVNCServer[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b8596d4664583e7c23ad5af6cabe5cf3189c557c166768589c7c77322d4a70a"
    sha256 cellar: :any,                 arm64_monterey: "2b2d24c9d3528ba81f7de80eb91448460108878488a04660ec296c36cbfa4edd"
    sha256 cellar: :any,                 arm64_big_sur:  "4d9c99dc705a710eaf23fc72a85193200dc08df28f2ea90b8020db76e73166e5"
    sha256 cellar: :any,                 ventura:        "e3c938ad6344e2af6bba985c177e2359323676d435419530d6e3a098cb7e9e6e"
    sha256 cellar: :any,                 monterey:       "30cd6e09106cb0fe56c9d31aee78ddd5f46568cb0e8de1be57a5642fe6aa3ff0"
    sha256 cellar: :any,                 big_sur:        "9a040c3f4ca5923040a2f27813fd176bfdb1a4c60c3ecb003b8bda0210e90e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3653eb3e793c0380213276fc06020ce4ce6778fbfbd10eee36aba880bc36f0"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/#{shared_library("libjpeg")}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    (testpath/"server.cpp").write <<~EOS
      #include <rfb/rfb.h>
      int main(int argc,char** argv) {
        rfbScreenInfoPtr server=rfbGetScreen(&argc,argv,400,300,8,3,4);
        server->frameBuffer=(char*)malloc(400*300*4);
        rfbInitServer(server);
        return(0);
      }
    EOS

    system ENV.cc, "server.cpp", "-I#{include}", "-L#{lib}",
                   "-lvncserver", "-o", "server"
    system "./server"
  end
end
