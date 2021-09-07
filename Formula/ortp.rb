class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.18/ortp-5.0.18.tar.bz2"
  sha256 "5740e5f1de912a1dd7d580027f46383364f6f1316ffbbe9a8c2658423f214234"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "63abdbc8f65a8d548420f18b386d556bf33789b299b228299ffd7f9eb2c1d319"
    sha256 cellar: :any, big_sur:       "448e9bb3f40bc4f646e37e9a5987bcfa91de8ecfa514b37d3123ccedf5000016"
    sha256 cellar: :any, catalina:      "f52d332f1a594d9b352f0c6baa258eb32264542f2a3a8526a877f70c0e0daa1f"
    sha256 cellar: :any, mojave:        "05956024f1e685a6e2b7ba106464eb8fc6a236559cd29356dfdc374be50f0a38"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.18/bctoolbox-5.0.18.tar.bz2"
    sha256 "45b8b17936d30f35dc066629ad7e3bf9c90f5efd5f66466f9e0af30a339741d7"
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
