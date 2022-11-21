class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.100/ki18n-5.100.0.tar.xz"
  sha256 "de63f1d6b86591eff69c502c8d247d6d86494abdd1d179ea84855c3678b30f01"
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
    sha256 arm64_ventura:  "6de5f1469ee3cde56d3493f74914de6e47145f07bf15a6ce6c05a69d653900b1"
    sha256 arm64_monterey: "49bec3bd51c9222ebdf972d1c2dc8010548b3324e103360419701d349f0129f4"
    sha256 arm64_big_sur:  "3071fa3860cd0f2722d70b3697cb04e9cddc50aef3662783695470a96ee59ac1"
    sha256 ventura:        "ea58a2589fb67ba20493078e97f60833b2ee4e8cf573cda79d5cbebde277e43b"
    sha256 monterey:       "c8561c2c33ab133de6dd5ee801669ad0ed8b1c8771cbd93749e74a1b4f7ce53c"
    sha256 big_sur:        "7e4a0f63e4c9f4f5f8f84e02492b2d98395960e008bc4f8ceeb589bb2bb95f65"
    sha256 catalina:       "943e5621603c97c08b458d2cb1f78b6545baab53c9eda0ee8e1a8faa9343590b"
    sha256 x86_64_linux:   "58d8219796df33a5f93151ed4e07c503c84736bac8d548c691d7aa6e94a73ca8"
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
