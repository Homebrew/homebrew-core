class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.57/ortp-5.2.57.tar.bz2"
  sha256 "4854f6ad4f34b4bfe8aefbe1642848d1cdac697be0a4eda3d520da61a5de631a"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cafb87f23db5c3f72cd9a5eb945a721fe847e99633932d71946fa6992fddc01b"
    sha256 cellar: :any,                 arm64_monterey: "d06a44b2b8cc784fa32ccb24ba859ce9a8b90c180abb2307988da3dcea771c7f"
    sha256 cellar: :any,                 arm64_big_sur:  "e2440eb36093d2f6ea2bb66ef202faca0578136329929a43e244115bfe1c4622"
    sha256 cellar: :any,                 ventura:        "cc1855286ac4924ba1341039b406884fa0fa6d9561b839a637785ccddad48092"
    sha256 cellar: :any,                 monterey:       "c8e26b710249f339c7753d9e941c1aff31d30f925a43cd8b820eb1a195cb1aa9"
    sha256 cellar: :any,                 big_sur:        "b9ff9cd3d241131ea1cf76409a5fa310bffb6304e7703f3071c1896a582dda03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f299fff62227c10ba9fb8967a46147a91167b98798f6bb01725a1fba84178fe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.57/bctoolbox-5.2.57.tar.bz2"
    sha256 "14d96829a32397c53a09b59c3cd284db8e4a1f9b6d542f4917768e329b722e37"
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
