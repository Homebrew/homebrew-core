class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/refs/tags/LibVNCServer-0.9.15.tar.gz"
  sha256 "62352c7795e231dfce044beb96156065a05a05c974e5de9e023d688d8ff675d7"
  license "GPL-2.0-or-later"
  head "https://github.com/LibVNC/libvncserver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^LibVNCServer[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ce1472b68ae1ac5412007a81f99ddec58cec02d3d13b4e9cceb1fe90202ab912"
    sha256 cellar: :any,                 arm64_sequoia: "4a3d1fee5603436a04b846cb9502e70fbee34a787d6a5201e1888845242de4f2"
    sha256 cellar: :any,                 arm64_sonoma:  "30629338dbd5ba92cb3726419a559cb9dfa0e7f39cce27976ce3967c1d0d4075"
    sha256 cellar: :any,                 sonoma:        "b7e7461e4689b9265688597301f7a15ac6b49f77a6a97ae8a5748c8ea6fffcfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cb88d51bf4a691357fe3020a78e367687b6329db0394eff5de2af46c439fed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4f2fb7d81aa49887b2c26579ca48af09812947fedca499f70d832e269cd516"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_EXAMPLES=OFF
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
