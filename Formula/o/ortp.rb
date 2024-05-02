class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.46/ortp-5.3.46.tar.bz2"
    sha256 "3ed9bf68ae2919d76071e84c648a05b1e846837a5ff68ae8ad7aaa9bc5c57803"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.46/bctoolbox-5.3.46.tar.bz2"
      sha256 "de92a48e458a996780053bd89a7f3abc0f8a0d5eb6a26a352f87cba21779c0b1"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f7ed367460e6fa0cbeb2d5420df755b478e2f9f641d30a8bba68c197ba700ea"
    sha256 cellar: :any,                 arm64_ventura:  "435e9413e21f29ca9bbe3826df4e13292f1c7f90aeb686677169c9693a7834a9"
    sha256 cellar: :any,                 arm64_monterey: "35b7f39c79113312cf799e9ac899cd2b9133dfd13fb22c3b838a311c848a6b86"
    sha256 cellar: :any,                 sonoma:         "9f6edb816fbdbae832696cab36d4590f68035131b6f058605f8cf9508eef471d"
    sha256 cellar: :any,                 ventura:        "7edfa3042db200c7eb72f48faf24573c684d097557d2843735d91bbeea16135c"
    sha256 cellar: :any,                 monterey:       "ee53216476d7af8212fad273a64f682ea4d019f1c047a3ea0d1e5aeea414869c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665c0f9a2b181da7f236e6eb6fe80c5008cc0240b852d1372c3f8979f7e75322"
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
