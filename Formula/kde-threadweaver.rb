class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.73/threadweaver-5.73.0.tar.xz"
  sha256 "7e1152a1cf73f841c3be5d73cb0d5e6e29ec700be859c94275c5c00e49488d38"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "31b662eb063e476c9b9aa6b1aa3c1e1143e892f96e33c5699bf3c73933f4aef8" => :catalina
    sha256 "7e91cff9074db139d7a35923c0241833823532fd5f53913986c0bf5424051399" => :mojave
    sha256 "63d505700bb14f015bcbd49033e32db8941a5c5980c26207e2c8e2d4ff4824da" => :high_sierra
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
