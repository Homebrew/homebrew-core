class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.110/ki18n-5.110.0.tar.xz"
  sha256 "bceaa4c861de372b77da5e850a50edf2815afe93d9d7f1b9c05f6d6667d2130f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "25b3f40daa9f8794b9bd84ea4e35bf145c6a3750f7e6a3abc891171a173c804c"
    sha256 cellar: :any,                 arm64_ventura:  "c78ff0750cc58beebb9c64ebff1d91688d5e6a896956c9286f046ef6c6425d80"
    sha256 cellar: :any,                 arm64_monterey: "9f98a9b030876f1e547a4027a02fe22919d6e0078ac3d8876e9760a89fc3cde7"
    sha256 cellar: :any,                 arm64_big_sur:  "c2296b52074b4cc1961e43e8de4be1d526f7852d2924cac29614c7d219340da6"
    sha256 cellar: :any,                 sonoma:         "025a754f2706f84dd3f8c891dbdc62b93fb52cccf27ccb46f72f2bc66fc57aa6"
    sha256 cellar: :any,                 ventura:        "5b31ea2eaed4adcea7d40163b49f8319af90b3d79dbafed517d06ec3250bb3c7"
    sha256 cellar: :any,                 monterey:       "19f126435900d4ad7eaa6400d968ee012ddbf76011215dfc02ff98214a2cf147"
    sha256 cellar: :any,                 big_sur:        "f9e1650d3f498cf4569a4d389c99fb9814bfea1a2c4de87d00e375d310f767b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d994cd87db01d7b4ddd8c39cf8ce9b0518795ae34d81cffbd0bceae38e3fab61"
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
