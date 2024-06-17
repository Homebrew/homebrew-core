class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.57/ortp-5.3.57.tar.bz2"
    sha256 "12232058b659bc6906675d972dfe5d8fa99c6d88e604182f31fe7617fe92e25e"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.57/bctoolbox-5.3.57.tar.bz2"
      sha256 "4ef48b42aa1a193e9ce585e77bb6f97098ab7334368b45d37a20dc64b8d607da"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "613c01fa271ae8040bcb1d9ce317fd6a59b5ee9c4020c5c704e62e9625ae2ec0"
    sha256 cellar: :any,                 arm64_ventura:  "791a0fd5432d0a99f8e2f472ffc674db27d1e9592de60d32b68b7e35964cd4e1"
    sha256 cellar: :any,                 arm64_monterey: "87412b8bd2357af8b3d15035c542ba1df4e61fcb348d782e24cdd9c537104774"
    sha256 cellar: :any,                 sonoma:         "40e72376155ef0bdd5a24aa6699c88081904773b0cc2759d35200c247cac8b7b"
    sha256 cellar: :any,                 ventura:        "955b728779cf5afd2ed76b5e5e32a1accca8fd25e0f75b6fbeac243eb3c499f1"
    sha256 cellar: :any,                 monterey:       "5eb39e605bf0fb50334ad49338f5c4ad0e8d84b1658190dd398a20538d7453e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0665e2286a6b78dfd9078ce3c3722afd4afac1c5300ba42052b52e3651042775"
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
