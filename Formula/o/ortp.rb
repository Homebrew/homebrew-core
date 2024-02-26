class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.23/ortp-5.3.23.tar.bz2"
    sha256 "ae6dce22f531324e4dcd31b2f7e349b69b2a5718aa86324a19a90bb2e486c8a0"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.23/bctoolbox-5.3.23.tar.bz2"
      sha256 "d53b13b8b029c4e62847d4c6a7126e5bd693c818c6f37298646b072eb784faa7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e0f564ab37ecd3cd445895900b2d33e24a3c36a9b9bd5979489325ae932e448"
    sha256 cellar: :any,                 arm64_ventura:  "6a7bd4a1cd7a32157e5c1c2246880b2f0a87d0f47bfefd124d4855bb6797b773"
    sha256 cellar: :any,                 arm64_monterey: "4bd35292a5328d2394c1562b7d3a530e2c09cb1bf0038d20954b535f073ed2b0"
    sha256 cellar: :any,                 sonoma:         "f942a445b4d2579bf975233907ff7e64ed1c02ea1884108ca84eed50da02e2ae"
    sha256 cellar: :any,                 ventura:        "30f6536edb276f4d2cc72830e73578359df7d3190fd43bf29bf3cbed0ee79329"
    sha256 cellar: :any,                 monterey:       "c71c2c6ba7484622d93c6e89a14d6f8adc1a86a2f4ad0eb3f6dfdbf70bf1c974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94b2ee939ce2d1d876979551d68fdfe10af666dd8af0cc678b5ee0bf3fdcfce6"
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
