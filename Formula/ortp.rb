class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://www.linphone.org/releases/sources/ortp/ortp-1.0.2.tar.gz"
  sha256 "a51551194332ac62b47865dc1e60893ece4922c489a7b0a780b8be562978d804"

  bottle do
    sha256 "6df0d199df16298cf0ec21e7d235ad6ea6702c4bab49cf736d84578afbb74df4" => :catalina
    sha256 "2858534d05cd9dd89af063341124f715aa200d74d893c81c7ee8f7e32bebe6e2" => :mojave
    sha256 "3e65235d8bf6ec1035762ab045259c154e650e737a925bd7d766cc3e52a7d0ec" => :high_sierra
    sha256 "1d762f2592d6e578d8e2cb68f5694daba1309c80f6be3124980356b526a12c0d" => :sierra
    sha256 "0c28ba67b9740081bf591b3cff97ca22fc9a6d5999c1a14f0cb9e3a0b19dfb43" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  resource "bctoolbox" do
    url "https://www.linphone.org/releases/sources/bctoolbox/bctoolbox-0.6.0.tar.gz"
    sha256 "4657e1970df262f77e47dee63b1135a5e063b63b0c42cfe7f41642b22e3831a8"
  end

  def install
    resource("bctoolbox").stage do
      args = std_cmake_args + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}
        -DENABLE_TESTS_COMPONENT=OFF
      ]
      system "cmake", ".", *args
      system "make", "install"
    end

    libbctoolbox = (libexec/"lib/libbctoolbox.dylib").readlink
    MachO::Tools.change_dylib_id("#{libexec}/lib/libbctoolbox.dylib",
                                 "#{libexec}/lib/#{libbctoolbox}")

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DENABLE_DOC=NO
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
