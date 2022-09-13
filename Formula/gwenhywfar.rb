class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/rdm/projects/gwenhywfar"
  url "https://www.aquamaniac.de/rdm/attachments/download/465/gwenhywfar-5.10.1.tar.gz"
  sha256 "a2f60a9dde5da27e57e0e5ef5f8931f495c1d541ad90a841e2b6231565547160"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c7b83b62888d39c6f1e18f603152db650b6d72e6f81a7cb061cc8bcbd998a80d"
    sha256 arm64_big_sur:  "273495183704bead4fa1077be3e057d1be7a86be76bae3f70b0d30cf6d0eae26"
    sha256 monterey:       "c8adb5792cd60ef01af64c0a2c3542246a0e7e5588a8c780fa4542ca157b790d"
    sha256 big_sur:        "c3a687c6a0b498a6ce19a9fef1ec9dd18cad56b733b53153ca4ccff6e73415c2"
    sha256 catalina:       "4c8a467bf4405f6591b49614c3b12b28c4f44b6b667fb92054e0126b52c62e0a"
    sha256 x86_64_linux:   "46b55d7ef906d5f814c5995943b5d555094f36b1c0bae588c5c8fe6ccfadbb22"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :test
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
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
