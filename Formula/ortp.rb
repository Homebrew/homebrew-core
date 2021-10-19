class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.36/ortp-5.0.36.tar.bz2"
  sha256 "322e6921d882e554eecb34a0ca11ec5b7065aa74453ef07cdb480a26b3c5b650"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "68de7de04fcdfe9b30f331cc79b2e658367bf22cfe511dd7acec6f5195233a81"
    sha256 cellar: :any, big_sur:       "8e2477c571a0cdabe84dc9d71fe1bcb1ca47ddfa57eea66d8644caa01688a458"
    sha256 cellar: :any, catalina:      "a004fb7a17c8f4153a52b8749e66486fd2f2ad1d7563547f8d16fdfef52a6107"
    sha256 cellar: :any, mojave:        "110abf0f0672df37cbd7e6178e06f2eabb4d56b752dec25a0fc9c76f9ad8d118"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.36/bctoolbox-5.0.36.tar.bz2"
    sha256 "766ab4f804ced6af56bb3dac49aee717a91e2ec6d4c402c26bf35958995b8a0e"
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
