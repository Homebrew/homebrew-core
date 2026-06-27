class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.10/coin-4.0.10-src.tar.gz"
    sha256 "13fe68831292e7e725e7db1c6909d2b4fe5802080474c229fcac14ddf6445188"

    resource "soqt" do
      url "https://github.com/coin3d/soqt/releases/download/v1.6.4/soqt-1.6.4-src.tar.gz"
      sha256 "1387d702df5578fdbc16b9c0a12dd52a68c0478f5e112cb6a45c033f02ba4d24"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1df1994743016c28aa47a458e72cee88fe56fb4572ca846c73ea61f4de50af87"
    sha256 cellar: :any, arm64_sequoia: "2e4a7cec5eea666534b2336bb2cffc67efe004d644f647562b56890a17af47f2"
    sha256 cellar: :any, arm64_sonoma:  "5f771d531c837a014672c8b8dc64a748551de93921492f8578c4501c9a0c91c0"
    sha256 cellar: :any, sonoma:        "d0dc3298fbc4f9ee7ab712ef0df5cf1d69aafa1bec22bca96e191081d380ddf1"
    sha256 cellar: :any, arm64_linux:   "b369aad80e2dba01a8913bf4ffe08cbf8f8c9a58b258b83e47be96151c7f13cc"
    sha256 cellar: :any, x86_64_linux:  "67597aab0907765b048a72969d991c6614ba285a49a56a3dc79ddd5dd9bb12dd"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "soqt" do
      url "https://github.com/coin3d/soqt.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "qtbase"

  uses_from_macos "expat"

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.13"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
                    "-DUSE_EXTERNAL_EXPAT=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("soqt").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DSOQT_BUILD_MAC_FRAMEWORK=OFF",
                      "-DSOQT_BUILD_DOCUMENTATION=OFF",
                      "-DSOQT_BUILD_TESTS=OFF",
                      *std_cmake_args(find_framework: "FIRST")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end
  end

  def caveats
    "The Python bindings (Pivy) are now in the `pivy` formula."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    CPP

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{formula_opt_lib("mesa")}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"
  end
end
