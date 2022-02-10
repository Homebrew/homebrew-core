class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.0/ortp-5.1.0.tar.bz2"
  sha256 "a900c032691c9c72b1f59fd786aabcbd813cb2aa57c36918a3c9b0d0d0ed8526"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4b9c8e0baa1623d63239b4dfb3a7e93471e31df932e61a180ad3f32563c02811"
    sha256 cellar: :any, arm64_big_sur:  "98cb0b4f9da341c6c80b776f9e5f52490af38aa737c0fdd0938360dfc2855afd"
    sha256 cellar: :any, monterey:       "015546dbb013f324f55e1e8b1e83c5d9059384e0179194a801d8ec7557116471"
    sha256 cellar: :any, big_sur:        "c7badbd8b31afcfea43ae035741d8ab7f29a316a7b0061c9df7d2b224919d4d9"
    sha256 cellar: :any, catalina:       "298251322a5ac298bbed5361084b634d08ab146941658a2e3f59bc00e87ad2cb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.0/bctoolbox-5.1.0.tar.bz2"
    sha256 "82fc92f5fc2242389794bf2ecdd278e08bcddc957e1ba46c9d13e8b8b422672f"
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
