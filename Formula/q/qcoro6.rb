class Qcoro6 < Formula
  desc "C++ Coroutines for Qt"
  homepage "https://qcoro.dev"
  url "https://github.com/qcoro/qcoro/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "4bff7513c5c8e301b66308df05795043b1792ed16381a484e5c990171b8ff19e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9ed424fd8ae02a63a497b56cc2572a003ce650d53431b0860581c77c223322b"
    sha256 cellar: :any,                 arm64_sequoia: "7bddcf4fa5cb6f63f5135dbb6a0da3c71d864fe4875dcbf307c932d62cc1a027"
    sha256 cellar: :any,                 arm64_sonoma:  "ae33df4621078549adf4b96608d5c0ec2688254fce0726bee3022ccd5915337f"
    sha256 cellar: :any,                 sonoma:        "54f735fe156db62ac5b1d8520bda73007e41c87987f872be613f29422339e7a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff965a3235d3c787027d3efb251f8c0ec492ecaa24f8533321ef1c5851dc727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce84877e4962f78f2beead7ca678a0fe4a5f0a0e0ab99de5328c9099a8445585"
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
