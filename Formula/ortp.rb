class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://www.linphone.org/releases/sources/ortp/ortp-1.0.2.tar.gz"
  sha256 "a51551194332ac62b47865dc1e60893ece4922c489a7b0a780b8be562978d804"

  bottle do
    sha256 "f49949830b4e6f09bb69c81ff2e2f8f3653bae1d648bc57db393bb92195fc260" => :catalina
    sha256 "1659170fed5ce087fe92e8bca8f8666ce1a2573220897df535a035582b8bd45b" => :mojave
    sha256 "183386b78f9bb94670265af5b717b604d678b399517e7ee9848b6999209755e6" => :high_sierra
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
