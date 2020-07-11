class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.72/threadweaver-5.72.0.tar.xz"
  sha256 "0fcd0fe46e8d2730986034b76b73fc1ecf4ae78f1796c6d5bc04a57ade0e20e9"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "87579bb26c763b47653d130f43f5c4d8f9ea0978542f4876eda324b453a38abf" => :catalina
    sha256 "1370c4617d49a84e6614ffc1b388cf3bf27f128b939002c3f6d4b45176f137b7" => :mojave
    sha256 "0cae32c5ea529e53f14898571c63198a77f3b480d12ca1135c5cc3e93952c2aa" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
