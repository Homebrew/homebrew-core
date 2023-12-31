class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.5/ortp-5.3.5.tar.bz2"
    sha256 "65459d91c40aedb99c80ee86b12ea29f1a275e0d6fe2acaf40b7ce542074f2c9"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.5/bctoolbox-5.3.5.tar.bz2"
      sha256 "d1dbbfe05fea4623e93469fd7dcf374c8680f461acfe8afc6ad22d651ec63320"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb562c87da7f2452d943e8749593d7d346c9085a3b87215fa3248e5eea72b777"
    sha256 cellar: :any,                 arm64_ventura:  "8cc515e1f5246679fad614bb21a6234562311e9aa2877c4d3d88a8af97b873af"
    sha256 cellar: :any,                 arm64_monterey: "3389e04eb416bd2b2ff9f1e259e3d81ee4e93e44d7a8bd0eefa672e590cc2187"
    sha256 cellar: :any,                 sonoma:         "04f29ec854302beaa29de75c678650686267391b73b22287f4a77cd3db3d379f"
    sha256 cellar: :any,                 ventura:        "7412e76fbf639b2c5b1ba3c50c45fafad80c1ded54a78c8b28901aeece0861f2"
    sha256 cellar: :any,                 monterey:       "e4209ef55444338cce9b45d09af978e5da6acd7d6e93aca55c9ec21344d58cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebfe540fee8caf0303ca206357f066553e8fc12cd7d5c98eb4e72661a1766f9"
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
