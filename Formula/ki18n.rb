class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.85/ki18n-5.85.0.tar.xz"
  sha256 "16b781a41e02341eeaef13dd0d7eb9dcacb5a491c53a6c8a9df0b2c17c6332c0"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/ki18n.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "65cceabd49aa5f2158639452e3a656151dffcccc2fc7441b37c497de83aab75f"
    sha256 cellar: :any, big_sur:       "a0276a67d4305be53b7d443478a3542c4fe536223d90902589f98c58f5ef242e"
    sha256 cellar: :any, catalina:      "2512273eb0214ad30833712e379432e895fa5b456e22415ecf5a38c0f3c6777b"
    sha256 cellar: :any, mojave:        "8399cf3a576f40a9522dd528cca2535064f47af10653e7047338f641ae2914e7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
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
