class KdeKi18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/ki18n-5.79.0.tar.xz"
  sha256 "33be21c3e4b0de8d942fde7a0d3c34a85cc48440ee745375b6a71ed6993f4a8b"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  revision 1
  head "https://invent.kde.org/frameworks/ki18n.git"

  bottle do
    sha256 arm64_big_sur: "3ebf24ce99afed3f6d8bc8127321611413fd88f5ccac67bd54ebfd5bfd97110d"
    sha256 big_sur:       "3fab49671721c2ae1ef5dbeb4f39930d81dc0b9f4dc5b53e264ed43edd70b209"
    sha256 catalina:      "99f6a40be017e93847a60d571b5493b124d132920de2d8bdf4a2d6fd2bfbe4f1"
    sha256 mojave:        "40bab468d976d14924e62eb899f8b3300505960a51001d3bc2ed9348358d0d7d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "gettext"
  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM 5.71.0 NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      find_package(Qt5 5.12.0 REQUIRED Core)
      find_package(KF5I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = std_cmake_args
    args << "-DQt5_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5"}"
    args << "-DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}"
    args << "-DLibIntl_LIBRARIES=#{Formula["gettext"].lib/"libintl.dylib"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
