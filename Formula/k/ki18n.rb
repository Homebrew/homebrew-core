class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/ki18n-index.html"
  url "https://download.kde.org/stable/frameworks/6.29/ki18n-6.29.0.tar.xz"
  sha256 "9037f3caa67768869f00ee257dbb35b81febe6ad600ed0bd3ffdf293c36252ba"
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
    sha256 arm64_tahoe:   "37179158215b1c79fa7405b357a1887b44208fc8e24571a1d1fbd194f7f650d2"
    sha256 arm64_sequoia: "a4fa33759f8a9e9fa0298415dc7cd24184e4ba4101ca71a04d63bce3e49598e6"
    sha256 arm64_sonoma:  "6bdd88a2c59abc0effa3bd73bcd966cf064964cee06adb29ff06902ee1c9140b"
    sha256 sonoma:        "634eab0200903f3b1d23265cfaf79f9fc8c3657dd88a05473fd029146c7a8b7b"
    sha256 arm64_linux:   "ae984674b86d63688affbccd6c93e8118d336bf70e4c014c692af4b6eb887a67"
    sha256 x86_64_linux:  "5ee8ce82f93ea8d38a0f4a66123bfeb80195f82b2d5aaf3c82f336ce3706852b"
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
