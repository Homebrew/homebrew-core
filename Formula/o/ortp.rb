class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.74/ortp-5.3.74.tar.bz2"
    sha256 "a7fef37c8abeb0223738e309d346adaf7efd0c1e8f6bb2780e1a82a65f17326d"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.74/bctoolbox-5.3.74.tar.bz2"
      sha256 "d1d72ed6a3812eae7dbbf1b61e4b4c0716a831e86024b1c99ef3f09271eeaa3c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0309cbc5e519e31fdcb9adb864c2e9ac9c7967cf5aa620bb528757189fc6b60f"
    sha256 cellar: :any,                 arm64_ventura:  "1bcabac05d20d5abb467a038217212c35a147fe6701c75a944e2a447728dea55"
    sha256 cellar: :any,                 arm64_monterey: "deb11e8555332505f16a6dbb955ad5657a367309050611d7bd89c06ab6d9d48e"
    sha256 cellar: :any,                 sonoma:         "394312049c97a6008c2fd7af80367482a6097d8a5ba956e8704a6b2f01977ee9"
    sha256 cellar: :any,                 ventura:        "bcef4b09d507f5c0e471f7b20b41174c1d9f8df0dfcd19076a918fc9c3ba286e"
    sha256 cellar: :any,                 monterey:       "cffbcf5b308932be2fe0b855949de43bbb829e44766378f961a21c2a36f03a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e56467a2b805774b20822d7953fe90a05919f0a6580c4cb19f0e9f70d159010"
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
