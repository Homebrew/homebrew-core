class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.51/ortp-5.0.51.tar.bz2"
  sha256 "0ae77f40321ea8b43376b7fda9d63cda16f9ef67de8e388871d1eaa01135c69e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "dcbd66f2a6723ad8564d9d66bab8c357c4af109d69c2fcd4c8ea9afe45311457"
    sha256 cellar: :any, arm64_big_sur:  "9971a950182266058eb40794fba93c7c13767fd0cea340fd2500a9d932232f25"
    sha256 cellar: :any, monterey:       "e5d2599d95319782fab2c5b35a07bf3fc11e9a9ff6678d91b35cf017f06ab114"
    sha256 cellar: :any, big_sur:        "f71dff59d332d3d9284663485017c37c0e55b2e999654383177d92bd9f323a5c"
    sha256 cellar: :any, catalina:       "58d42a81d57ce4a9e0658b7f955e7d872724e4b4c3323d43b6847f84b96170c5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.51/bctoolbox-5.0.51.tar.bz2"
    sha256 "88068640706479c350844678e6ac554c98f7e6cb6cc4ef18e0fbb7fa5800654d"
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
