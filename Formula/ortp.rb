class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.63/ortp-5.0.63.tar.bz2"
  sha256 "0182305e590ef62c3e29a64eea506c3e3282ffb6acff48d107689545a7ceb09d"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "dce450bf81b4462e312856c6e44c28495844d59eebeca0ec873a95bd4fcbf498"
    sha256 cellar: :any, arm64_big_sur:  "87af543cb16c22240ff95ca29de37d2263fecd047a14153c905aaed57c8c6f6c"
    sha256 cellar: :any, monterey:       "a6a3247bb76e7fe0aa9ebebca248a8a020968519245ac29700a3c48b2bea8f5d"
    sha256 cellar: :any, big_sur:        "a5c1e679fd123711828c1267c83732e0818f7f3204e0d8949723f9fbe71acae3"
    sha256 cellar: :any, catalina:       "3920fd7d06f9610aa51dcba05d261dfcd8809f82c34daf7e37e4fcc4aae60fd8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.63/bctoolbox-5.0.63.tar.bz2"
    sha256 "ac08b7d5ca646e0cf35dd504c1ac1ef520ab497df1a8cd4b00dc429368698ec5"
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
