class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/ki18n-5.113.0.tar.xz"
    sha256 "fc94ba4cd1a4f0d25958764efcfc052cbf29fcf302cd668be2b18f62c6c58042"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "56a38014c964358d01b2216bcde3bbf2b5b8bad0c25e2bc365b0d13c6514951c"
    sha256 arm64_ventura:  "32c4c6ef171d2289b3aa6fd45208bfff4d343fe74d6b83c014f0ca9e89951717"
    sha256 arm64_monterey: "e779a4fad606b1214caeef4a87ae8a38c64e273b2ffe5a9e85bb8288fe617c67"
    sha256 sonoma:         "976b281d2d2dc7411a1acf00309a58e66263465e1c25bf121bbc0d2379d083bc"
    sha256 ventura:        "64279c85325050983fb3fbbeb74ac6ca707a09e3d47f29ef04ca2703f518e064"
    sha256 monterey:       "08500741feb0f9913798257c34aa5166ac07e10d0dfdc0d868ceba6ec7ee96e1"
    sha256 x86_64_linux:   "cbea00ebc8661dd2af154c6d142e0853fc944f965d1ecf0fd4e85d74d6d1913a"
  end

  head do
    url "https://invent.kde.org/frameworks/ki18n.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "iso-codes"

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5"

  def install
    # TODO: Change to only use Python3_EXECUTABLE when KDE 6 (Qt 6) is released
    python_variable = build.head? ? "Python3_EXECUTABLE" : "PYTHON_EXECUTABLE"

    args = %W[
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
      -D#{python_variable}=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    qt = Formula[build.head? ? "qt" : "qt@5"]
    qt_major = qt.version.major

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version unless build.head?} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      set(CMAKE_CXX_STANDARD 17)
      set(QT_MAJOR_VERSION #{qt_major})
      set(BUILD_WITH_QML ON)
      set(REQUIRED_QT_VERSION #{qt.version})
      find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED Core Qml)
      find_package(KF#{qt_major}I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = %W[-DQt#{qt_major}_DIR=#{qt.opt_lib}/cmake/Qt#{qt_major}]
    if OS.mac?
      args += %W[
        -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
        -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end
