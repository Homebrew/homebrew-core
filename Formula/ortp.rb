class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.51/ortp-5.0.51.tar.bz2"
  sha256 "0ae77f40321ea8b43376b7fda9d63cda16f9ef67de8e388871d1eaa01135c69e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "53d96d0aa1084391518ae4d7b248bd5a025b4e75f7473a0110ea63e872035686"
    sha256 cellar: :any, arm64_big_sur:  "a490870836537a4c8a3a43e1ee3da37807b65df4518d001058ba81b2966a9f81"
    sha256 cellar: :any, monterey:       "5fa3c2bd5cb6ceafb2ce73a050bdde95e24d6f299f23c21d1e5e5d0216207a8b"
    sha256 cellar: :any, big_sur:        "c210089138448b9aa56868fc705f9c1b1130e527d2c6a210ae0685de3cfee861"
    sha256 cellar: :any, catalina:       "fe373a23935ba80686198ba348cc43f0ecc0fe02c40b9f699fbdf4a6874991d1"
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
