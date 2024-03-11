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
    sha256 cellar: :any,                 arm64_sonoma:   "9a61839f53c211d54f49e57eb1d557d64c85ea33794bb3a080390551e10858ec"
    sha256 cellar: :any,                 arm64_ventura:  "350f98cabefbfc850cfca21f52fe98e5266314e3bb4916a3ee4bd4e0d16a529f"
    sha256 cellar: :any,                 arm64_monterey: "53a87ebf5e29366e37ca85bbc204ff120cd52a33711bd033d3ed01aa7131b77b"
    sha256 cellar: :any,                 sonoma:         "53c190e20c3682a555897fce192f422a5a8984a1c8d80e0f371c51edbbfb2cd1"
    sha256 cellar: :any,                 ventura:        "70c6e6cbc599876408c4e26f0f4c5f8ac98c4c0e82a0897cfc1e906e6fb905da"
    sha256 cellar: :any,                 monterey:       "6ac46732c45ea0944fc8366a2b7e56d8a75363f1f4f33728295eaa348f1c9b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400e1856d972d1314d41f6a073ef1631fb2e15f7526b6abcbb0a50e4c35f4e09"
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
