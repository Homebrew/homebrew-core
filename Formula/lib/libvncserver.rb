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
    sha256 cellar: :any,                 arm64_tahoe:   "80e5ade9dc3708e05dbc026946bf865042b7cd630846beec5bf73aa47d6c6b48"
    sha256 cellar: :any,                 arm64_sequoia: "8dc88d75ffe2cf292dd44b3207f9c9fae289066c9dc5f4a004c8e86671ca4d06"
    sha256 cellar: :any,                 arm64_sonoma:  "e295b31d29e37617212cf0d69dbdf3ee07ccfa30e2f2610b8d1704a7e0847656"
    sha256 cellar: :any,                 arm64_ventura: "6cd487a3c48729af0d6be975995826b830d81ebf7d32b9a64e6d50d6ba59245b"
    sha256 cellar: :any,                 sonoma:        "c26cb98d88424e0a498ceee1eeb5009b9b11b55db0df0826c9d7e7da94e1c317"
    sha256 cellar: :any,                 ventura:       "c6f5a152415c9036c91cff25c3ff2f0d0cf78de4bf09c4af260cd3ef5bb8f640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0297b512315813159854b8450fdad94fb8f6db1d7bceb4de3d0e236331c75c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c1f651bd1e6e13695746043eaaba56b733f8ed4541bef2cc3f259ae99d02c10"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@3"

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
