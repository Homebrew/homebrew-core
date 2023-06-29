class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/465/gwenhywfar-5.10.1.tar.gz"
  sha256 "a2f60a9dde5da27e57e0e5ef5f8931f495c1d541ad90a841e2b6231565547160"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dbe12c37f9775b4ba2a779257be4b57dded51c4aee433fe4b3665929430db9c5"
    sha256 arm64_monterey: "090b514a0757752cfc3a1a3a6a4b73f0a2f28a275c22b2ae62f13be5cd507710"
    sha256 arm64_big_sur:  "f2b97500a509936e740b32332ff80f42dbe99f75fd238996a07003e2273c3825"
    sha256 ventura:        "0d783f3b2ff8dac5a1d5d913fb5150b8eda6827b83b00623bc39a7f3f90d4c17"
    sha256 monterey:       "120195030139f081b5e356303154bdfebde752512ddd6575f2821e46478b0062"
    sha256 big_sur:        "45a44e84dae31250c41e0123a22b8eedbd17762390daf51c14aaaf150c186e17"
    sha256 x86_64_linux:   "880d3c424d5aaedd1d64bc59aaad0b836d9f676454979f82707e4dabca075cba"
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
