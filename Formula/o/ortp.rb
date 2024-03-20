class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.35/ortp-5.3.35.tar.bz2"
    sha256 "561835131a21f9ae3e8360897bf397941c7575902d636494cfdf18a56c3e2194"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.35/bctoolbox-5.3.35.tar.bz2"
      sha256 "f38cc54181dcd6f0265c5252deef28cda51d3e4fce56e32a4e139b8481a1a22f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f03597cc50817c35271061739aa19f28a3602bb6a7231d70e76c48c783e1125"
    sha256 cellar: :any,                 arm64_ventura:  "74be1c227442fd3184e492161a7d64a96aba1bff4c9e2381a12aec467ad764a5"
    sha256 cellar: :any,                 arm64_monterey: "bfb8c090ee48847141b0ad24ed63a5beee1c5942bbb5284afe41ac6bd4e6b4e2"
    sha256 cellar: :any,                 sonoma:         "96e661ca8f2c5e08315aafbaaa2eafa9c5733663a505ff47e65dfb2a8d2cc4ca"
    sha256 cellar: :any,                 ventura:        "0017373d41c07ce8ed8a051c9dd1aab81be51fefc257cb4daf9e4d284d18fbf5"
    sha256 cellar: :any,                 monterey:       "7bfa854dbf6350d43734a2ce01e8283c4b27e7cf95c9afb2d52916c079645bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7a64dd595646e1c124089c33c35073eeac3706aec24b16e06f0a752f8493ed"
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
