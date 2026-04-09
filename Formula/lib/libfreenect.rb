class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "3c668053db726206a8c3a92e92e91ef7a64407968f422b9c4b828d0fd234c866"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/OpenKinect/libfreenect.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7dbfb69f15f0be8a9f5c9fc6e39ebb8c5abe9d120071ab3eca3f6a1f1ca057d6"
    sha256 cellar: :any,                 arm64_sequoia:  "933ad28174edd8c5301568af01a0a14138166bc3abf51e09232b8feb6f5610a7"
    sha256 cellar: :any,                 arm64_sonoma:   "2aee8ccf6079d0f96b58e1301986514e2de5279f13fbc6f11dcb0415137069e8"
    sha256 cellar: :any,                 arm64_ventura:  "0a7c2f69766090429451b4922549d12c0fc9863a5a02a481996814692277c554"
    sha256 cellar: :any,                 arm64_monterey: "f4451759cebfc907e6a83d2284cdcfd4250f84956623a35f59ec5904a3ff220b"
    sha256 cellar: :any,                 sonoma:         "b904426be3a9c6ed08769df3ff687a0864dcffb2175a508705783504fa62ee5c"
    sha256 cellar: :any,                 ventura:        "a925b6f78825af0effc793d6b7377e7280ff79ffc7dc3c5ebc4eb7543757bc11"
    sha256 cellar: :any,                 monterey:       "9e1a123c0203dcccea2b45d93dffaf1d53d8d4653fdef6897bcb56fa211e101a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5ae7b0d8bd7d70454f7179215f28270e75adb75b89fdd0c1ba54ee7f7ee0ac1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1719d3272072df8495b60651dbfa15b865d4db9e0e481a1a050ba04afca4fc13"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = %W[
      -DBUILD_OPENNI2_DRIVER=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libfreenect/libfreenect.h>

      int main() {
        freenect_context *ctx;
        if (freenect_init(&ctx, NULL) < 0) {
          printf("Failed to initialize libfreenect\\n");
          return 1;
        }
        printf("libfreenect initialized successfully\\n");
        freenect_shutdown(ctx);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lfreenect"
    system "./test"

    system bin/"fakenect-record", "-h"
  end
end
