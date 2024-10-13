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
    sha256 arm64_sequoia:  "62a3746f10e2264779137d156e68697b40f562690434cbb83d3bf9ce1dad6fbb"
    sha256 arm64_sonoma:   "8fcdcb168c435353e08b7faae158c672ada3b908db6c1a73435226d77203f2c6"
    sha256 arm64_ventura:  "8dd914e47edf5ed454e4cace3c2aa4cf3fc1a05f20bea019a8c018032cf2b8ab"
    sha256 arm64_monterey: "040d7ecc2deb34655f6c56912114c515e7243a53e291d3a751290bf725bd8a68"
    sha256 arm64_big_sur:  "13670a1756bac7a4e8cecc363321d1609103164636ac198b952dfbc26b2a2cdf"
    sha256 sonoma:         "769755ece1d223465e685f591caf8c53934571eb0e4b29f6aa967fb1820d30c7"
    sha256 ventura:        "6f4f5f09ad7cc1bba9112c0e1198ee7728985f2d403d40608e51d158dab4cb1a"
    sha256 monterey:       "72979aefc21e5c22c33401d21d232396b9026c57cab53438c0935b3ff74b1adc"
    sha256 big_sur:        "8f583511d6309b20d9722259b6e17bb3b49b09646bbce022b496af4f260f4f24"
    sha256 x86_64_linux:   "771e98641328a98fbf0a789d12c6a0bb59a1f083c7142e2b25807505f58ce7cc"
  end

  depends_on "gettext" => :build
  depends_on "cmake" => :test
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution
  depends_on "qt@5"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "go-size-analyzer", because: "both install `gsa` binaries"

  fails_with gcc: "5"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-int-conversion -Wno-incompatible-function-pointer-types"
    end

    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    guis = ["cpp", "qt5"]
    guis << "cocoa" if OS.mac?
    system "./configure", "--disable-silent-rules",
                          "--with-guis=#{guis.join(" ")}",
                          *std_configure_args
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
      cmake_minimum_required(VERSION 3.29)
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
