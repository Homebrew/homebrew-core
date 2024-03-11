class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.33/ortp-5.3.33.tar.bz2"
    sha256 "17f2ea014df9f10579bc5add9c15c9387e1d74bfe0ede12ab83bfb7970e11e08"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.33/bctoolbox-5.3.33.tar.bz2"
      sha256 "b63d404d33713b41bc5296ea83bd9b8b2ca6698e5b17788d53ba25459ff66def"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fbacc424a903e3d5050c10cd1d48fcf44fcab7181a7fb3e915019b8d9b73ad9"
    sha256 cellar: :any,                 arm64_ventura:  "8670c923e0910f6686565b1b305b88123ba30becd5361bdb6c21c4bc9674a247"
    sha256 cellar: :any,                 arm64_monterey: "42ce2b36fcf0f3e77c28dfdf89990b1c76715454fa19b05d56bad800d82ec8a3"
    sha256 cellar: :any,                 sonoma:         "6f6ed06a547d90b80872a7ec116db1f040a588059000b217169d63acaf9a6278"
    sha256 cellar: :any,                 ventura:        "49448fe1ad1e6ce1c281751cc28e43a01777f7e461ab5798d76728efea9097d6"
    sha256 cellar: :any,                 monterey:       "434bf7e008c052ed2143157c3cdf8459141a802a733dae7dc4c51de9e8554c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6023163a73d738e26c237bdc57caf7258cf5a91af42e54833fd1bfcf92591830"
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
