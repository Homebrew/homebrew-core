class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/threadweaver-5.78.0.tar.xz"
  sha256 "d972e78e5ce89004d52c08e689b539877f20c036a1ef0383d2be02bc6e7598d2"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "28dd6d1f3868c90ab19f3e3c48784ebc57c85618a44fcde9613c4019e118c15b" => :big_sur
    sha256 "8c006eed5b2ddbbfadf1ab2bbff67680dc2c38371e73abfbc5db5487a5a21eec" => :arm64_big_sur
    sha256 "552abc63b2913731230d3cb65c19d09d556aafc6784f8757a2f605ec751ee0a3" => :catalina
    sha256 "263e2279aaec1e389ff66d52cb0ed372087e1097560011468f876c18bd249319" => :mojave
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
