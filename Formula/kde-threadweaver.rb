class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/threadweaver-5.75.0.tar.xz"
  sha256 "d082f863fb119e2b98c9e01877b2730eedc0b54392449e3cc9bd54d7803d16ff"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "f803750e847123597d76551e6d277f5a006301412a506ba226d2e33cb7cb5842" => :catalina
    sha256 "b9c2f7899640087646398f92aa7eb85e26b861fd470bc2c4cdb86f3bd994ea7a" => :mojave
    sha256 "33ef7e1e69f50ee47b522e437d623fd44ae5d37cac5a8829e776b778b2b0cb62" => :high_sierra
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
