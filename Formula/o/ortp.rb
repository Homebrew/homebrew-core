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
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.19/bctoolbox-5.3.19.tar.bz2"
      sha256 "3886e6a077013178e4d18a19c830bb7933a8d02b591e85b7abc26571e1c4aa0a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22fc1841d46e3f698f8af7b9123f352e684c7c38e0f634180881f8aa7405e4e6"
    sha256 cellar: :any,                 arm64_ventura:  "96474476df4e7a5c53ff496afc29d0fbf780245c3129a3a51c47333747960c5f"
    sha256 cellar: :any,                 arm64_monterey: "3534d316eb639d0c2938523619a00ad157da245112c510e8af1b6f1aefebdd8f"
    sha256 cellar: :any,                 sonoma:         "db537113ef1e461bab95ae4af54a6ec7ee0929133e8a9d1c8ffb3419f0eb3c80"
    sha256 cellar: :any,                 ventura:        "3c7e748bb817420ac5473494cfa7d4054ff81bb5e07b03f032d5c2f77a0f36a5"
    sha256 cellar: :any,                 monterey:       "277c3a811a94cb512ee20b07da711440744c842bb3024dbfed1529abff97f438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11af6049e8c005d0380ab21d2666120a76fd390e97ff8cd1dc826a781c44728a"
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
