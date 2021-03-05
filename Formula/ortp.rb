class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/4.4.33/ortp-4.4.33.tar.bz2"
  sha256 "89edfdbc92ed5c27e4c35de64de07934a9db6e2579f8dde5f8a14d7df3cf9768"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.linphone.org/BC/public/ortp.git"

  bottle do
    sha256 arm64_big_sur: "29f49cb6278f9d2789b356532e6ca6044eaa5551fddb26e32e4d08c3fc890003"
    sha256 big_sur:       "196c32a21c33f519a568f2dc80fa036ad33231c945f678e73a60f6c256e738d2"
    sha256 catalina:      "0f73a234c5ec22bcdc326a1961bc1138c841bad878f4b56980f019967a0ea7d8"
    sha256 mojave:        "c90f847eb30d9fa0ed91bbd66c9e0c6770028c232ce8a7bbc35a4ba1495a8186"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/4.4.33/bctoolbox-4.4.33.tar.bz2"
    sha256 "4aafca6f4abb02666aee24518ce42029739507e5f149728f29a4bc9ec2ebce1b"
  end

  def install
    resource("bctoolbox").stage do
      args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}
        -DENABLE_TESTS_COMPONENT=OFF
      ]
      system "cmake", ".", *args
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=-I#{libexec}/include
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
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
