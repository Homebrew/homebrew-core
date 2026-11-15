class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/ki18n-index.html"
  url "https://download.kde.org/stable/frameworks/6.32/ki18n-6.32.0.tar.xz"
  sha256 "b574b381e7510cf3b14d6a16f6ed5670220f10df7f2494c21a579d20ca1d017f"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  compatibility_version 1
  head "https://invent.kde.org/frameworks/ki18n.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_golden_gate: "f5cba2ee272625c6e2f1acd155564102f6fe4608798f3bdef4a705f63f025bf8"
    sha256 arm64_tahoe:       "4b10da778bee5f9a57d759d7858de8db215ba87bebab02eca0e0900675e19e13"
    sha256 arm64_sequoia:     "b84358c3961084aff06b52e583a08e7f4581b9735bb95a6dc2fb8f6f3a1b0908"
    sha256 arm64_linux:       "1cd7c3a90e8da80836a3f785bb2cefa007e0b71c30a32819961d45edefcff7a0"
    sha256 x86_64_linux:      "6ffdcb38cfffc6718659f9c29ff37a47082bdaea3276345d10bbd36b18599edb"
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

  deny_network_access!

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
        -DLibIntl_INCLUDE_DIRS=#{formula_opt_include("gettext")}
        -DLibIntl_LIBRARIES=#{formula_opt_lib("gettext")}/libintl.dylib
      ]
    else
      []
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end
