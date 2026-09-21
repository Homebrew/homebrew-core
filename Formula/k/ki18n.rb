class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/ki18n-index.html"
  url "https://download.kde.org/stable/frameworks/6.30/ki18n-6.30.0.tar.xz"
  sha256 "dfbfc8af89b3bc68810b094bf87746db87c3eeb35b75caeb1882681ebed563bd"
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
    sha256 arm64_golden_gate: "98b4bd90d01747af2c6a138cf55f65fed4bd833d54ca1f44e7185a0c10d80dac"
    sha256 arm64_tahoe:       "9b8601c9fc867831a7a1751b50ab1cb8b90df6bd4bafbe4f4478b5430eae7715"
    sha256 arm64_sequoia:     "ca6c7cd4d206073c97d01b440af72f42f975d346ba355b1628a0b2470e25f3bc"
    sha256 arm64_sonoma:      "debefbf7574353a7330a0c68221e010ebb7d2966d0166037b94e5d8d7f6a5fe7"
    sha256 arm64_linux:       "deb5a713091f63fee078a54f6aae04eb2d4eae2ce73f5877ac9b2fcc92652269"
    sha256 x86_64_linux:      "f5ce106e4864a0143deff49d6116b7a0adb408331fff989dfd4a30da63436380"
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
