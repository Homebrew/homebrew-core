class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/ki18n-5.101.0.tar.xz"
  sha256 "bf1530be9279d476c0531988eeb1c032e208f6010c8f00880bb5d694229fef65"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/ki18n.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "65fa762162be209d346815beb6c05e7c989ada313fb66f273d569fe34817fdab"
    sha256 arm64_monterey: "10a1bdbfa8d7709b43e90f40fefab4debd0664bbcd84e51ddd6d49359f13ae26"
    sha256 arm64_big_sur:  "bda696c0235f2f93fa120224dc432fcdba5c0ea7c923bfd1b861100ca0e416f6"
    sha256 ventura:        "60ff407c7a9342ce659552c15eb2153cbad419fbdcafd67dfdde7245b641b553"
    sha256 monterey:       "5138baeb4ecc3d954afbc94223c1a3a2d8106d2dd6f9b2c4445a18e0e8806d3f"
    sha256 big_sur:        "4f0fedebe6e0a7bce8bd0a62fc5ac58e393b3a21530e1edcf578f7476b4ca3db"
    sha256 x86_64_linux:   "5c3b66325ab39069c406e86c709a7ecafd28e45f7a52754ff526999bc15afeca"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"
  depends_on "iso-codes"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      set(CMAKE_CXX_STANDARD 17)
      set(QT_MAJOR_VERSION 5)
      set(BUILD_WITH_QML ON)
      set(REQUIRED_QT_VERSION #{Formula["qt@5"].version})
      find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED Core Qml)
      find_package(KF5I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = std_cmake_args + %W[
      -S .
      -B build
      -DQt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5
      -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
      -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
  end
end
