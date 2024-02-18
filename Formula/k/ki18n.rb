class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.115/ki18n-5.115.0.tar.xz"
    sha256 "d4fc34762137b5f90df78294370ffb345b6932552137359d15cdd157dbd7d6fd"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "f675a187e8fc3705e218dfb744cc5e1dfb2e05c64ae42a6a23a0116b810e13c6"
    sha256 arm64_ventura:  "e8699f7cbcac22838fcfc9bd7dec107629226d30c07a525ead8fa79f52142f1d"
    sha256 arm64_monterey: "ccaebb1539d77ad8713965303921511d6637d7b0ecb1b344c78b25b063b51420"
    sha256 sonoma:         "a64c78221a4c43ddd5335df6d7e16dd5498ea271da64f9f694dd1a5abfc47f6e"
    sha256 ventura:        "8fd24d63b3768f4f671b01f690e846f373d1e556a840caea34f7164d03b0f8ac"
    sha256 monterey:       "d4edc373fa84d617469cc31fac3ad2c862931eff48ee287e6ab6d459b5419cb3"
    sha256 x86_64_linux:   "3d33b503c316011aff0c1d30cc2b6070fbbba597629d0f20a1cb8ba37eee2dda"
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
