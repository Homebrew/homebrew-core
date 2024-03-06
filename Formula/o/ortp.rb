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
    sha256 cellar: :any,                 arm64_sonoma:   "451ce72127400a3da8b3151403ac9896f00bca2fa85ae24e5ebf7b9475f9d8df"
    sha256 cellar: :any,                 arm64_ventura:  "0ed8eef9ca1d5d77f4d368457fce2f3fe9ae170e74fbf4aa989dc3d0e5f8e4f9"
    sha256 cellar: :any,                 arm64_monterey: "524034b5d40619da48744dcef5de7efd720110f24cd51cd92a64059c68c8d743"
    sha256 cellar: :any,                 sonoma:         "2b6a9576fccb1ffb46ba2db329bf4659a5c94a32991f3601c34537b98d0a7f07"
    sha256 cellar: :any,                 ventura:        "fcaef72fbe691f3855a6d3e376c666b1bf9ad7be87436cad53d052636f5bf1bb"
    sha256 cellar: :any,                 monterey:       "c081c40d601f1f8b997cd92fd3e8318f8b0779ac8dd9474277cd4a537e6db23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d456b25e0dba1f69fd4931f3b725fc0469f1b1c34aa98e1ff1a618be744963"
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
