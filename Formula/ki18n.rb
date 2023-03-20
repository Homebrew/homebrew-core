class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.104/ki18n-5.104.0.tar.xz"
  sha256 "fe815b9e28c680fa472c7ab56e4d7934a8915f19409734a13433797a4be14ee1"
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
    sha256 cellar: :any,                 arm64_ventura:  "c64ee2b990abca45c92454ce2721e6856e9f5eba2db4f8a32f349c1927c94b28"
    sha256 cellar: :any,                 arm64_monterey: "843873fe132706b6a0f4493e8c656e633f65ac0b20248ced785419e5dac016d2"
    sha256 cellar: :any,                 arm64_big_sur:  "75855ddd0773f1dec095e066b9c6d00ad3757db48a9909d2beceb9d05ad25772"
    sha256 cellar: :any,                 ventura:        "005536c8d471a093191f09a657043c864b9a2c9cf5ac5885ccfdca23b9adcce4"
    sha256 cellar: :any,                 monterey:       "7095ddc5cffefb22fe82f69a3596a238398bfb0141c013f25557a3d2ab6e8e72"
    sha256 cellar: :any,                 big_sur:        "f241873c4b3642ac4bab34d4e75c88cbb0d78d82a6dc91720590d0f437d07cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01e76347ff832ecb184db06031ab04c7423de8da0b4d95fe8013ec0fb8bca20"
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
