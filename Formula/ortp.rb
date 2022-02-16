class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.2/ortp-5.1.2.tar.bz2"
  sha256 "ee571a59c45e59d323347f2130015e71764f2147c8a77a0eca632e0443fe04a9"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb77bb47a73ffe727efca223e13a589886e6022c7ff9a6cd4848229c07223069"
    sha256 cellar: :any, arm64_big_sur:  "3fb140876e7af8ea924ed88b9ab284980fe3ab28796307ee523a3dfb2cb9d3c4"
    sha256 cellar: :any, monterey:       "fb043beb342a1182c6c460c06a7ad62bc8adaacb226d7db73b76b6b6128da913"
    sha256 cellar: :any, big_sur:        "e1959a156a3ae255ad537cfc50214539da55a4a553acc5d2ad5990ee4eeffc8f"
    sha256 cellar: :any, catalina:       "3668de243e09dbf73ff9b9744bff9c71bbc59a00ae794241b453658fed721290"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.2/bctoolbox-5.1.2.tar.bz2"
    sha256 "2f839e1e4981f14687554df0140f7e1e48ebf7102bffbfc43a18acc78af20470"
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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
