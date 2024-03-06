class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.27/ortp-5.3.27.tar.bz2"
    sha256 "eeaaf415c35ebcefb3686bd7c6907e36ee607eaa89b105aab35a17c56432e61e"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.27/bctoolbox-5.3.27.tar.bz2"
      sha256 "a7bd94e5c3f43d6e43b3aa71817e5137454a8fceee657df4be3fa736fe752c50"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "362978e525177fcc0a237986c1c4cfc5cd628a2e6499a6eade777462dc3fbddf"
    sha256 cellar: :any,                 arm64_ventura:  "4e9465d8240295cd5146137a3d5784582a061594f0d3f92b7dfaf520245091d7"
    sha256 cellar: :any,                 arm64_monterey: "b813f09c0334f022a76085ecee233a3dcbf6981572bd7ba1db43c970f46cd9e1"
    sha256 cellar: :any,                 sonoma:         "a7ba0fccc976ccdf693c1248bba0928330b2d8aec141e93bacb97525ece91bce"
    sha256 cellar: :any,                 ventura:        "ef9ebbe77059093fde33568d3cd35cc52085e64d6b8f29841bdaeee55040d540"
    sha256 cellar: :any,                 monterey:       "e81e540cc3959e562790568266708a3b4ca918998622d196be91b429134201d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61aba93d1c94e9c91aab413d2a7fdab691a74974807032378f406305c40f3e85"
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
