class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/threadweaver-5.79.0.tar.xz"
  sha256 "297ca4454e9dc526af8033ee47932a63e3ef3d76868a75dfa66df0f7a04d5918"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 arm64_big_sur: "d6b999d021af28fa3bed64f2cc7aac26b9b80e266e16d5f42aad21aa365549a9"
    sha256 big_sur:       "cc0c3d6035feea18171feff8f6310fb5df7d58a631477c2537477316d921feb7"
    sha256 catalina:      "1e224681d674951d07488d6b2abf0e67f753533994c8c7403f47f0600a36a21b"
    sha256 mojave:        "98c69380c4e892705ade2564216a1d661757251f1c06af5d9212dbaf6a435f18"
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
