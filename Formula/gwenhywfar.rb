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
    rebuild 1
    sha256 arm64_ventura:  "3b16dc36d846d40413b684b6bb4b58a5c83102c04e200241c70ec5851a92ceff"
    sha256 arm64_monterey: "a4a56e458f247380a5766377a718b25e8488101cf528d791d3e54f0b70d0d289"
    sha256 arm64_big_sur:  "ed089ad54b5d4f967a27517759dbc2e89a76324c90e9520e28239cea774c2337"
    sha256 ventura:        "ba9fbffed9b93f9cb60cb36086ab7ab90b31a6578922698f1eb21d0d2ec3ca1e"
    sha256 monterey:       "1656453fb187a695e920960e8e95c4504b428c867d5124ab5ee6d180eec7a5e9"
    sha256 big_sur:        "583bb7775e565b01b56787c51fcbf48a98ef9a38e247781c60a54839303aef90"
    sha256 catalina:       "39e119ae0c67f3282b9323d79253f47b471e347fcb737f523b1d74fc1d128eef"
    sha256 x86_64_linux:   "f48d3868cd3b66a3a76897984c2d567f7c35e21dc5376d030c62b550233d59b5"
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
