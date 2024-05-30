class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.54/ortp-5.3.54.tar.bz2"
    sha256 "835b9c93f592f9255b591c35110f3a1f392eae78a17df2f2e17ecda8423e8e24"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.54/bctoolbox-5.3.54.tar.bz2"
      sha256 "9abe2e08b103ecfeaf1a738ef77ef0eb36ed142fbf16ee43990236892c9ad57b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "674a4cbfc9508265360a0528b3dd3b8c8119b523614a4099434645a5ff99d7c7"
    sha256 cellar: :any,                 arm64_ventura:  "f0781f33be9eb4476df127974cf62ab5f5ebc43b8b005c92d93d8d337fb05857"
    sha256 cellar: :any,                 arm64_monterey: "90254208f9454592cf4ec86c568e8927b9cd89e73f13a99407e6be38047c761a"
    sha256 cellar: :any,                 sonoma:         "c75e1ca760ff894ffe5a8675914849b82f58660f13fc7c3cfbd78a4bb3b77d59"
    sha256 cellar: :any,                 ventura:        "9a3aa11d47e8f23b8b8be46faafd0fea2f039b7f4f42c834e184f7da0384c24c"
    sha256 cellar: :any,                 monterey:       "193a45dbea28b2bc1ce9a1e2dac375ea5bca8494ba7d01d011f27378dce1133e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f06ff0287fa3cc572d579ec32a6dbf5c021da28385c512c90bec26538d752b57"
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
