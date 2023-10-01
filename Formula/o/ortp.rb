class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.107/ortp-5.2.107.tar.bz2"
  sha256 "b5847322413a2b6475cdd60f17ef43bd3b30828f779ee14d3e762dd507574f05"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e4b16808b11033f1ef87db0a0932bdef167b5315525eefa1e3dc2a0df436655"
    sha256 cellar: :any,                 arm64_monterey: "923dc467162d1df411ac272828a9036bf633c346bce20e0ab663db875135f6ae"
    sha256 cellar: :any,                 arm64_big_sur:  "b1efa9f7e6fad53153307d22eb6a27e06be686a95a2199ae7a7a123c5121803b"
    sha256 cellar: :any,                 ventura:        "30fddd4fb6ab4c1b25475273abe6604250b72c3639c5b1c48d9e8e0d91b072be"
    sha256 cellar: :any,                 monterey:       "5201de7213f3ef471c2e1173804b5df3813a03bfa94ea7ddabbcb89199f6789d"
    sha256 cellar: :any,                 big_sur:        "8239118c3f16bb4405c04ab50374409d1efae0bd6e4eb15c2e175897eea39627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05b1cdee27efe4522e3ca63b7a554f47e33f13121083b09484ee8cbc1dee21a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.107/bctoolbox-5.2.107.tar.bz2"
    sha256 "d765c67761f094a6bdb1f1384564ca1a7a7f91375f464c5d1986abe01f53dbab"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
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
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

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
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
