class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.77/threadweaver-5.77.0.tar.xz"
  sha256 "4f898107074943f103fd9d4ee2b82cddcb705382424bd47fcca21b11c167d8f2"
  license "LGPL-2.0-or-later"
  revision 1
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
