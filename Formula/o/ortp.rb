class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.0/ortp-5.3.0.tar.bz2"
    sha256 "7e8ab74665c93672f778d1ba9c11d8ff8b582195c3b8bf16465d61d1efe06417"

    depends_on "mbedtls@2"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.0/bctoolbox-5.3.0.tar.bz2"
      sha256 "7bf02fc5e54a2e29775c22437bed492935cb87a872962721e854c8dee115bd8a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93e4a6e384e893e3070f50d6d2adb6f7f74a16e3cb12266c35d32cddcd732b72"
    sha256 cellar: :any,                 arm64_ventura:  "472766bdf4005bc27e57ba1e15b897eb2d36f475333a1911b9b898b7bb0b58de"
    sha256 cellar: :any,                 arm64_monterey: "f16871ba304dc46e2b43e9c578a01030eb4d286397fcc50a191c46db2d86d065"
    sha256 cellar: :any,                 sonoma:         "d2343bffa97c636c05e45ccef445d747e45b6989e0a44751e6d7a19e02033b22"
    sha256 cellar: :any,                 ventura:        "b46e51c57cbd296693e9fdaffdff6380919739412d85da7347d028ca03b164d2"
    sha256 cellar: :any,                 monterey:       "682e9f66f372092ff5d3d43f53fbe52955d5ab026786360b4a8d7e5c2f21cff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303382f2205a9957e6166fc89250769044597cc0ff22f0db8f3fa5b6b3d2ae3b"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    depends_on "mbedtls"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
      args << "-DBUILD_SHARED_LIBS=ON" if build.head?
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
    args << "-DBUILD_SHARED_LIBS=ON" if build.head?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal version, resource("bctoolbox").version, "`bctoolbox` resource needs updating!"

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
