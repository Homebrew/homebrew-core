class Qcoro6 < Formula
  desc "C++ Coroutines for Qt"
  homepage "https://qcoro.dev"
  url "https://github.com/qcoro/qcoro/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "809afafab61593f994c005ca6e242300e1e3e7f4db8b5d41f8c642aab9450fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29e63a82cea7891ef2e9844a57e7836d9c4ebf91db2991432038fa9ce4b971a6"
    sha256 cellar: :any,                 arm64_sequoia: "c77df01948a62ed7857b568b86ea585018632050d2ba57872205a3ae54eadb76"
    sha256 cellar: :any,                 arm64_sonoma:  "f0d57a2e74521709c59b8c8c13727dcc91127378507b5c43e9757e5aaa4ddc44"
    sha256 cellar: :any,                 sonoma:        "4dcbd1c72b2d23a8a7c870611ac6de0f47d6c473c49da1fd111908b253914a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c9a6c92632c060f34b85158517ecd7d204da2ebab40b7994e8c9228b613755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ffddc636d502cc3d763fab6deef4348c4f77c7b8e6d14594cfd30d5cdad1d2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtwebsockets"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DQCORO_BUILD_EXAMPLES=OFF",
                    "-DQCORO_BUILD_TESTING=OFF",
                    "-DUSE_QT_VERSION=6",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(QCoroTest LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)
      find_package(QCoro6 REQUIRED COMPONENTS Coro Core Network WebSockets Quick Qml Test)
      find_package(Qt6 REQUIRED COMPONENTS Core Network WebSockets Quick Qml Test)
      add_executable(testapp test.cpp)
      target_link_libraries(testapp PRIVATE
        QCoro6::Coro
        QCoro6::Core Qt6::Core
        QCoro6::Network Qt6::Network
        QCoro6::WebSockets Qt6::WebSockets
        QCoro6::Quick Qt6::Quick
        QCoro6::Qml Qt6::Qml
        QCoro6::Test Qt6::Test)
      qcoro_enable_coroutines()
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QCoroTask> // from QCoroCoro
      #include <QCoroSignal> // from QCoroCore
      #include <QCoroAbstractSocket> // from QCoroNetwork
      #include <QCoroWebSocket> // from QCoroWebSockets
      #include <QCoroImageProvider> // from QCoroQuick
      #include <QCoroQmlTask> // from QCoroQml
      #include <QCoroTest> // from QCoroTest
      int main(int argc, char **argv) {
        QCoro::Task<int> t = []() -> QCoro::Task<int> { co_return 42; }();
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/testapp"
  end
end
