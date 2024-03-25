class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.37/ortp-5.3.37.tar.bz2"
    sha256 "bfacab68b1fd9d2439acfa8578a5406369ae0f6a70969fcbce829ecde760391f"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.37/bctoolbox-5.3.37.tar.bz2"
      sha256 "55da6932e61ec12f6f312e3e3dce611a94d27e36e14a30bf92586e2be3009464"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecb5847597db294ba548278e3d67daa25ffd5c0a0532b3e1f6e1d0d1d2ecd62f"
    sha256 cellar: :any,                 arm64_ventura:  "bf9782982c090eae8a2c7bf082690cbd0b48a6c1fa4870e9e0fa2bbb5687779c"
    sha256 cellar: :any,                 arm64_monterey: "14c07ce50dddb8bf0d15787270225fa64a94140fd8669f70008c3e0705d4a487"
    sha256 cellar: :any,                 sonoma:         "9c5e1d2f66e1b605391ec5f2c56a32f5449e32aa9c84a9937ef8293b37064b83"
    sha256 cellar: :any,                 ventura:        "d8e5f1f5e6bb5e50daa91ee0e7ff506b9b62c8a9b4bef0f18823c2e13dcdba35"
    sha256 cellar: :any,                 monterey:       "58b64c4f612de61d43143ff697f53982b7afe65ba450c5b8ff8066681227a697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15446d2702eba2c6e1416820c555f1635bfcff107bf08beed59678e66e3f1aea"
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
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

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
  end
end
