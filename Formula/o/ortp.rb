class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.42/ortp-5.3.42.tar.bz2"
    sha256 "a30e337d14733f1a73adea4d23aef3842643cfc8386fc0b3dcc5419732d7745f"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.42/bctoolbox-5.3.42.tar.bz2"
      sha256 "2bf49014eb8d4e74edbdc5f4cafc7edaf4395af959e444135c723ddaafe1a5a9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b08b6ec775fce17a8af471333d7954098496df1a0b8061707a8368323c9a7914"
    sha256 cellar: :any,                 arm64_ventura:  "94dceb5ca801008807fcb9177fb4fbf750ac3fd9d431763509cc6c417823fb91"
    sha256 cellar: :any,                 arm64_monterey: "ff9422d66445cb1919d262dd802718aeaf02668cfca0729bdbb759d8e78ec6d0"
    sha256 cellar: :any,                 sonoma:         "7cfa5530facbc89c056c47f3f6c531d4f0fa125bd70e8b13ba5e7b3d4548c0b7"
    sha256 cellar: :any,                 ventura:        "be2aafcb0a8353f9d5e8c7b56f098248348875a02367cdc509e84b1910349982"
    sha256 cellar: :any,                 monterey:       "19e8b6f53b2ed16253829c008f29bd3681bfed8dc37598a6a7af360cdbe917d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fa4109ba75451e2d3f48b661079d5ff802fc14dabc869359bb782578095abe"
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
