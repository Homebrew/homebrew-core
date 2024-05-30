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
    sha256 cellar: :any,                 arm64_sonoma:   "838f2ca436a693f2a8bbeb2a2063150823f9d4dadf019ca1492e880c31da4383"
    sha256 cellar: :any,                 arm64_ventura:  "33b06ca17f35b9bc8dc4a0b80eea943026bf8ea19e3785b7ba53feba34979a11"
    sha256 cellar: :any,                 arm64_monterey: "14faed46adbd5e4656964409be14ce3e5fe7c8401ef1a41740680a6d08cf5720"
    sha256 cellar: :any,                 sonoma:         "894783bd991d5b0842d844935958f526307a4f9df75037607e4b72629a267688"
    sha256 cellar: :any,                 ventura:        "50d70c1250e4dcc0acb95cd7899f7bfc1ea82116fa921fd4a9330436bdb33435"
    sha256 cellar: :any,                 monterey:       "bb290f37e4f083e9f28e09be0638cf5d79e1444f3f6546f33959ce8c62fe88bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113aa5f636bb21c0bdba4a67842797becaa132a00b23c2c2cb0a5adfa6f01f64"
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
