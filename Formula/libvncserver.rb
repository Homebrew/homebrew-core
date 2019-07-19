class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.12.tar.gz"
  sha256 "33cbbb4e15bb390f723c311b323cef4a43bcf781984f92d92adda3243a116136"

  bottle do
    cellar :any
    sha256 "eb46c752190ababd6214df10185386988e6bf7822264c7f3cf0fd8a82a8ee920" => :mojave
    sha256 "5488af95ef114b62f63a389d35988bb74c4ee31673d1226c1b7818ad0dfed75e" => :high_sierra
    sha256 "0780be062ffd9d420539a01b23cd591cef537d4d3256294574812ca5593b342e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib
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
                   "-lvncserver", "-lc++", "-o", "server"
    system "./server"
  end
end
