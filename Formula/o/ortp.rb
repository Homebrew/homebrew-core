class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.21/ortp-5.3.21.tar.bz2"
    sha256 "71884b94d4c61f1c5d7f4518a52108ffb759bdaf08f9a19391ca3fc174e025ba"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.21/bctoolbox-5.3.21.tar.bz2"
      sha256 "4660103992ffd60857cebc592c91e121b26a1a3d3f8a3162e30cf5c4797c5e80"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b204adfbeb967087d8e8fc9ffb731bb5e5bcd2f005ca56f25bcfb2c6e61f1809"
    sha256 cellar: :any,                 arm64_ventura:  "6d6ff342bca0b6930849b5aed2631d787f9189ff6301b41158d87850174c5d73"
    sha256 cellar: :any,                 arm64_monterey: "771278923c86221d9e530a01ef6138199ac90d89a5cd554770be1ae57fb07a8c"
    sha256 cellar: :any,                 sonoma:         "b49c6f96fffc213d542ccd81495692bf8a1f0348e5650617abdfa940a448a3e8"
    sha256 cellar: :any,                 ventura:        "a0dae65b4fdafa044960ec71e3effd50662feeade5a15c0ded8314d62acecc64"
    sha256 cellar: :any,                 monterey:       "8475a5d65a599afc1e5352555ccc3f6d23592891ddefd48c86bbba7281b72a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6953aa749b19c8a731a755baaf41498078a11697976f1e54501858902e9d3488"
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
