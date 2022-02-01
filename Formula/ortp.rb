class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.67/ortp-5.0.67.tar.bz2"
  sha256 "7961e1cbfad025376ab8ebbe7608e497bb6f75f2c92a3c58b60af80709d86747"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "bb29f0f4b441ee497e7bc8985f81b368988a17ab60f611144cb190cfa8195c1b"
    sha256 cellar: :any, arm64_big_sur:  "27c0cc6ab5fad74b103198fa7fb486bd20e9625568b5b4d1a59fe6c247e62a87"
    sha256 cellar: :any, monterey:       "6db87f10a122e886564a4bf91acd4bfa187e70fb149d077c2d5dc2e47ec909b6"
    sha256 cellar: :any, big_sur:        "150f21c8b62a0fc8bb7689fb14d940b3d794cd5f663fdb9009075f22aba8bb7d"
    sha256 cellar: :any, catalina:       "15a57706b008850c4a03a3a9b68959d4f0935b7e60e4827df4545063ef68f49c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.67/bctoolbox-5.0.67.tar.bz2"
    sha256 "7ede83ad993290c2d490a62ab5b1e4fe14ce800a9af85526e15a70adad1bd202"
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
