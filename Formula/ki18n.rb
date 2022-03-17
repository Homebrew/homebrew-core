class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/ki18n-5.92.0.tar.xz"
  sha256 "058032e8e9556f1dadcf0c2bd633da6cfc9673e966dd113388e2b8aee2395777"
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
    sha256 arm64_monterey: "8a25ca3c4e89e1e21d6ecc015fd4c454fe70952178650656d47a1515566dfa21"
    sha256 arm64_big_sur:  "712779c93db0ca77b30353c9b68cba97332c4bfb742d8ccd82dc4dfaae1617a5"
    sha256 monterey:       "abede5e43b9eb1fbca5113a1545eb646d7422b198cce653f0ba01ced68a499b7"
    sha256 big_sur:        "432638a9391fc35b7674956fcfd180fc80d17d0c7eee397942f8c83302fbb569"
    sha256 catalina:       "4144cec293ff3c4f47078eaacd40a54f32f32b26e6cc6b51d43f55a7052e56ce"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "gettext"
  depends_on "iso-codes"
  depends_on "qt@5"

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
