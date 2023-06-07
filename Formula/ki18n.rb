class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.106/ki18n-5.106.0.tar.xz"
  sha256 "f1281bb3249b9cf99f89a0750a114858d013655000cb6bb24e5dc332c57b9b4c"
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
    sha256 cellar: :any,                 arm64_ventura:  "7b871925a173d894872917b2317786dbb7bb4f167e3eb2334e549155fa1ab87c"
    sha256 cellar: :any,                 arm64_monterey: "1ad6ccae98eea0d69e5918681619c5ea8ae4f509b70fd4b70c84cd61dc12269e"
    sha256 cellar: :any,                 arm64_big_sur:  "f7b35542ca33ac7d80417552d24502d933729ac4f559ed0648ac6b927b37aac6"
    sha256 cellar: :any,                 ventura:        "8732bbd24f3d452bc95a8771a5a21bfefdfea1347aa41abbedaef194bbfd9d04"
    sha256 cellar: :any,                 monterey:       "a0a52fa2391d369738bc603ec0b136cefaef072cb6c603d86a594745bfe4f38e"
    sha256 cellar: :any,                 big_sur:        "f6396d49a09a1c0db7e11a1201fc65683a93df045a7b95c383323e44c7cb1576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14dab85a8c8735bc63f0ec0a70aac53d4077fab4f4a1a6fe2bfb151c8119609"
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
