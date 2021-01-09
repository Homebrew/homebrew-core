class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/threadweaver-5.78.0.tar.xz"
  sha256 "d972e78e5ce89004d52c08e689b539877f20c036a1ef0383d2be02bc6e7598d2"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "82f6056c178a78be529ac55154c17a08f4c6f27540c8c314c06384fdbd104f34" => :big_sur
    sha256 "8d05d6b6cf57272d490c40906ab41131a00574996b4947b650ca79d3a9de9bfb" => :arm64_big_sur
    sha256 "662638057a18a3e558ad94de5c653f31f0d54dad17a68a84a23dd2762839d86e" => :catalina
    sha256 "bbe2e94b988134190bda49c4c74d112ab31941da55fc00c52de7930f75caa46e" => :mojave
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
