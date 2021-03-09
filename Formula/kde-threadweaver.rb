class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/threadweaver-5.79.0.tar.xz"
  sha256 "297ca4454e9dc526af8033ee47932a63e3ef3d76868a75dfa66df0f7a04d5918"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 arm64_big_sur: "4e2cc8b16301bc9e2fc14fda3748bf5c6806f1a5354fd8975bffe543afd609ac"
    sha256 big_sur:       "14e86bf2b254bf6cc4a03eef9ce8fd440172befc09987963c06490bc5fb71475"
    sha256 catalina:      "4ed11a2a30e6c38fb227c7b0177e7759c155320d4b3dd7de9a64386f3fbf9ed4"
    sha256 mojave:        "47d34ce1fc476cbbbad3c8d7344a202a3169d450163e33cbf8d389dcf5f4bcf9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "qt@5"

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
    ENV.delete "CPATH"
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
