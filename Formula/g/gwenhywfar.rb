class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/501/gwenhywfar-5.10.2.tar.gz"
  sha256 "60a7da03542865501208f20e18de32b45a75e3f4aa8515ca622b391a2728a9e1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8dd914e47edf5ed454e4cace3c2aa4cf3fc1a05f20bea019a8c018032cf2b8ab"
    sha256 arm64_monterey: "040d7ecc2deb34655f6c56912114c515e7243a53e291d3a751290bf725bd8a68"
    sha256 arm64_big_sur:  "13670a1756bac7a4e8cecc363321d1609103164636ac198b952dfbc26b2a2cdf"
    sha256 ventura:        "6f4f5f09ad7cc1bba9112c0e1198ee7728985f2d403d40608e51d158dab4cb1a"
    sha256 monterey:       "72979aefc21e5c22c33401d21d232396b9026c57cab53438c0935b3ff74b1adc"
    sha256 big_sur:        "8f583511d6309b20d9722259b6e17bb3b49b09646bbce022b496af4f260f4f24"
    sha256 x86_64_linux:   "771e98641328a98fbf0a789d12c6a0bb59a1f083c7142e2b25807505f58ce7cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cmake" => :test
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@3"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version == 1403
    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    # Fix `-flat_namespace` flag on Big Sur and later.
    system "autoreconf", "--force", "--install", "--verbose"
    guis = ["cpp", "qt5"]
    guis << "cocoa" if OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_c"
    system "./test_c"

    system ENV.cxx, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test_cpp"
    system "./test_cpp"

    (testpath/"CMakeLists.txt").write <<~EOS
      project(test_gwen)

      find_package(Qt5 REQUIRED Core Widgets)
      find_package(gwenhywfar REQUIRED)
      find_package(gwengui-cpp REQUIRED)
      find_package(gwengui-qt5 REQUIRED)

      add_executable(${PROJECT_NAME} test.c)

      target_link_libraries(${PROJECT_NAME} PUBLIC
                      gwenhywfar::core
                      gwenhywfar::gui-cpp
                      gwenhywfar::gui-qt5
      )
    EOS

    args = std_cmake_args
    args << "-DQt5_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
