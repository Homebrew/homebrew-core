class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/ki18n-index.html"
  url "https://download.kde.org/stable/frameworks/6.23/ki18n-6.23.0.tar.xz"
  sha256 "c492ac5c9258d84c732addcb3a53dbdb3ba86912773f1d6f4193218657e3182f"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/ki18n.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4905f09abbb99a99be8405a1ab9a12abb3cc989ba4a444fd68e26d5bce82eef9"
    sha256 arm64_sequoia: "e5ee25fe9314a1704812f40a38694cda3229badcbc84bbf7d3688154509bfa44"
    sha256 arm64_sonoma:  "e40a6c5c0b67acb5dfede5db3821561443f81c0d7ad24e562616c19a4d2f4689"
    sha256 sonoma:        "6ee9797fae8ac5dc65bc56251d626adbe01296c7518bf46a4dd026878ff9de67"
    sha256 arm64_linux:   "a58d742ed128e44de27991519596b80d50ee02831f98ac44a9103db48ed4e144"
    sha256 x86_64_linux:  "88c3edacb246d5e1bd62be5ba01d0e717364cbd3c91eea16603dc08d24485372"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "gettext"
  depends_on "iso-codes"
  depends_on "qtbase"
  depends_on "qtdeclarative"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
      -DPython3_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    qt = Formula["qtbase"]
    qt_major = qt.version.major

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      include(FeatureSummary)
      find_package(ECM #{version} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_AUTOMOC ON)
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
    CMAKE

    cp_r (pkgshare/"autotests"), testpath

    args = if OS.mac?
      %W[
        -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
        -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
      ]
    else
      []
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end
