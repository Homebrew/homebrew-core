class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/refs/tags/LibVNCServer-0.9.15.tar.gz"
  sha256 "62352c7795e231dfce044beb96156065a05a05c974e5de9e023d688d8ff675d7"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/LibVNC/libvncserver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^LibVNCServer[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "865a4376a6361437e19230eb55c8baaa89c837e693e7a352d080a91050c7c2ee"
    sha256 cellar: :any,                 arm64_sequoia: "09c5d54a804cd66267e2f453978281e19edbcacd434b6507bef2d928da69a79d"
    sha256 cellar: :any,                 arm64_sonoma:  "18f58d8fedea600268bb9a70a470fb279c1afe0086b09b8282e1454904bf3c0c"
    sha256 cellar: :any,                 sonoma:        "7a127ab1078d09af7ad9d28f554a8ce44fcc32e0259db44031b2ac8ece3b41ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a66daa25ce9cdb07ed0000ff45f93f3f6101621188f712f8a2d97b216891af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce999949a58f1263bd09e67af8a39f1709c0f5d8a055696151b0594a1793fda"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@4"].opt_prefix}
      -DWITH_EXAMPLES=OFF
      -DWITH_GCRYPT=OFF
      -DWITH_GNUTLS=OFF
      -DWITH_OPENSSL=ON
    ]
    # Workaround for CMake 4 compatibility
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"server.cpp").write <<~CPP
      #include <rfb/rfb.h>
      int main(int argc,char** argv) {
        rfbScreenInfoPtr server=rfbGetScreen(&argc,argv,400,300,8,3,4);
        server->frameBuffer=(char*)malloc(400*300*4);
        rfbInitServer(server);
        return(0);
      }
    CPP

    system ENV.cc, "server.cpp", "-I#{include}", "-L#{lib}",
                   "-lvncserver", "-o", "server"
    system "./server"
  end
end
