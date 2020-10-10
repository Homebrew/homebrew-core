class KdeKi18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/ki18n-5.75.0.tar.xz"
  sha256 "71f22a4ef4a9e750a1813c9fe37b552d9e053e6e2249079b5908d078160130d3"
  head "https://invent.kde.org/frameworks/ki18n.git"

  bottle do
    sha256 "da4981215236a96dfecc3a64ee85b5d5a2942b9c101cdfbb0896093d60a33642" => :catalina
    sha256 "52e4c45fd1b4c18bbad54ba48d44c542525f8f58ad20a6396ef377abba72734a" => :mojave
    sha256 "93fb10c573cfc3d451983b53d96b5099f187f081087c1e13cad1123baf98fc58" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "gettext"
  depends_on "qt"

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
    args << "-DQt5_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5"}"
    args << "-DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}"
    args << "-DLibIntl_LIBRARIES=#{Formula["gettext"].lib/"libintl.dylib"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
