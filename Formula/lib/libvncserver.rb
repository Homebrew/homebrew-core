class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/refs/tags/LibVNCServer-0.9.14.tar.gz"
  sha256 "83104e4f7e28b02f8bf6b010d69b626fae591f887e949816305daebae527c9a5"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/LibVNC/libvncserver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^LibVNCServer[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c3d95ce451303d3e11655c9a0f050e8804a73a2f4cb1ae5549846fa6b4b7c31"
    sha256 cellar: :any,                 arm64_ventura:  "5212065cfd69a225a5daa89fe45a7677d2a2716970f69d7015b4206b6b90b633"
    sha256 cellar: :any,                 arm64_monterey: "44455a6842335f99c4722e9fb89da75c1ce7af49778ee66bb08670e3ece665ab"
    sha256 cellar: :any,                 arm64_big_sur:  "fb8f83791e2207e227b625710686602862a6fd9cd8ca88940e6c21a63fdd9435"
    sha256 cellar: :any,                 sonoma:         "cc50311b539c8f12e2572644be531a6ea89fed8bf8bd185d678a59d45b39f7ff"
    sha256 cellar: :any,                 ventura:        "fce52496a16dacb10b307481ce5faff96613aa9329cb63850f7f05be37909d79"
    sha256 cellar: :any,                 monterey:       "35af138621f6415eec78d4e2e6e2f8bc5f74dd22bf38cb0f3c34fd2bd32c84df"
    sha256 cellar: :any,                 big_sur:        "2f83240c0b85bdcf83c84cc6ba18ab00c8eb097520eea08133df3ab1d3c91ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d783c095df406689824ecfdcb6ee757526b6a5cf7b7951ef268d6ee8a6243f"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}",
                    "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
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
