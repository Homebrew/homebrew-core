class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.25/ortp-5.2.25.tar.bz2"
  sha256 "6653a893d9601317926546e999bc494c4abd1e3ed5bf86bce392aa648e59079c"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17cdd395c781a0a0f2a9ec90dad3cce43ba536f3fd6e31b9b5e6486c50fc9aeb"
    sha256 cellar: :any,                 arm64_monterey: "c501c6f2e93602152ec4c41552447b827c9b971a1a64a2c5d6fe08b7815b9e03"
    sha256 cellar: :any,                 arm64_big_sur:  "1853c4047f70b65397093837ce8b3178a893e7e2f66c34b54fcfe12852f61a1c"
    sha256 cellar: :any,                 ventura:        "3df06ccc53ee986809c74b6253c487cbf93cdbd4942442b6de45d03c89b6e630"
    sha256 cellar: :any,                 monterey:       "e1d98e5eac62fc5a488d39f8a0f566820167eea167cd5a6f42000f42a6abdbf0"
    sha256 cellar: :any,                 big_sur:        "f9de23f1226ec57eba1a1afcd36426b8a321d2522b67036f93774867c81be1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baada87612f486d4ea249b1f0cbcfe9a87e6e66c548278041374b76320c30668"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.23/bctoolbox-5.2.23.tar.bz2"
    sha256 "6ef9a9ed98a48cc328bfede9f7a15a931036934418caeda5967456b88df694dc"
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
