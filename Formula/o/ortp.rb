class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.84/ortp-5.3.84.tar.bz2"
    sha256 "e0b539a0021c8b6babca5efddc9362954148824f59c4c316d772a124ebbb51bd"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.84/bctoolbox-5.3.84.tar.bz2"
      sha256 "1c9ec26a91e74f720b16416a0e9e5e84c8aeb04b3fc490c22a4b2fc10ab6d5e3"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4db45336c212cfb572b3ff42b878352733679fdbc11a79f6dc3dda037f220bab"
    sha256 cellar: :any,                 arm64_sonoma:  "4214e613d3563fdb8e737376eabc9576e7b01ec5d001082e19169f1b9b6dff0b"
    sha256 cellar: :any,                 arm64_ventura: "9cd9109b254d1d76307bc9c779d6e2b6da0ed264297421aac06ba61fdf2a66a9"
    sha256 cellar: :any,                 sonoma:        "635f5d33e32f95b633923cbcb168f0be9705699b83da87a7fc3eb590f46de10c"
    sha256 cellar: :any,                 ventura:       "113dff9d0907b040807916b184d3c722be016f952f4b0f7ca895c4eb4332fe6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2f06f9efd8c6b09a40b5cd555d1a1ce5c782463cf60a5ddd324885a272b124"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    depends_on "openssl@3"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
      args += ["-DENABLE_MBEDTLS=OFF", "-DENABLE_OPENSSL=ON"] if build.head?

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    ENV.append_to_cflags "-I#{libexec}/include"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}/Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"
  end
end
