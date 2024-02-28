class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.25/ortp-5.3.25.tar.bz2"
    sha256 "f6c792df7f6fe0eab1e98613a0416d5c706ddda7737c1ecabb30225d59f533fe"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.24/bctoolbox-5.3.24.tar.bz2"
      sha256 "929fc987e7f035c97a84159ead5af175b6b5df7dfec7ebcbf79d8903ff062a63"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c55e818571da893316d8e1620d3c512c6008e3be68245b664098497e4f6fea3b"
    sha256 cellar: :any,                 arm64_ventura:  "2836a0a0f68a393e4c4f0c0cb86f65cc6f644443de6aae6eb0d9258ef12d25ae"
    sha256 cellar: :any,                 arm64_monterey: "caeb290b537154cfc51580b5a2a5f9af114220b43222161d6d959c9ce506f2a0"
    sha256 cellar: :any,                 sonoma:         "4c3e0790207bc4b18cb643c3ac90198d9849835f0e273394ecd2f3af0e890b95"
    sha256 cellar: :any,                 ventura:        "3e3d890a93d5ff14cd02364c876c712942c375345c1c8b19883e06565080e973"
    sha256 cellar: :any,                 monterey:       "4251f48230c40e191337671afeacc04ccca1c2feea2072390b10c0bff7d7905c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc59347011ee087db410ae3f23801786b6993755a8ec8587dcea301c31428b75"
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
