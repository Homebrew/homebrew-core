class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/threadweaver-5.75.0.tar.xz"
  sha256 "d082f863fb119e2b98c9e01877b2730eedc0b54392449e3cc9bd54d7803d16ff"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "4c193cb67d347e478fe5e1dbf9497ef6bce628da8975044ab3119ee28709caa6" => :catalina
    sha256 "9106cc8922688c54846dafb52030644dc248e3917e65638fc40d59090cb11ba9" => :mojave
    sha256 "c5b8a683bc9e1263883570777c9d2357df4018ef6536ca73a7bb646955bcfcbe" => :high_sierra
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
