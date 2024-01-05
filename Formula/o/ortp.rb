class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.7/ortp-5.3.7.tar.bz2"
    sha256 "8cc6eb91f81c5283decfee0b6be6540cda388ceebdd82d7ff5a37e9f50540c32"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.6/bctoolbox-5.3.6.tar.bz2"
      sha256 "ccbe12e82319a362a5342bdbd8bbb1fef1151ed378c995364104dd24405fbe9c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6540f3af4e161d8b5460f8f228e0c8c903fa47477c1a330461d2303d6fe9f16"
    sha256 cellar: :any,                 arm64_ventura:  "46a21155f5ab503840d39357d1234bc8327e70663f82730510456f97dc2605d6"
    sha256 cellar: :any,                 arm64_monterey: "71aef2b30ad102d671bc58423a75e84bf2ad9967ccbafa57803770ec2dd82d9a"
    sha256 cellar: :any,                 sonoma:         "d5f8827fb4bd1fc55ac256fb179561d416fc0de46faed225eeac81320921b1f8"
    sha256 cellar: :any,                 ventura:        "482fa1994b76bd3a2da291ce9f1e929c37d9bdb9e8238fd2fd9e5fbfac642ed6"
    sha256 cellar: :any,                 monterey:       "017fbdff42362095e9a297c2781994d816d76db2a442deb6dbb2c6cda537d114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf6d3ec9114a9fdc153adc1d1fc03f4d346e1c025989f1207b69e1f4a74bc67"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
