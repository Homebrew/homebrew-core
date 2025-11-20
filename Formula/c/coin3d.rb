class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.6/coin-4.0.6-src.tar.gz"
    sha256 "e04a600809593feb2acbec4282803d1673926ddfa1d9fcd402f35ec26fc52e7e"

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
    sha256 cellar: :any,                 arm64_tahoe:   "40a953c5da778240ee206304efd942c4c6417e30520700ac37f54b17840d9559"
    sha256 cellar: :any,                 arm64_sequoia: "f97cbf252a50387b2589db4f56bc474c45235095a017bcb1afd033e09c1f7c23"
    sha256 cellar: :any,                 arm64_sonoma:  "a516f84b868ed0911b2d7ca6d3bbc29252501955a146147c8cad25f2914aced7"
    sha256 cellar: :any,                 sonoma:        "758e7e7da2579c5462b5beff4370099d7d640d513c4ba2688b3a9d539b29270d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8857329b9b978a804adfa800124678ae573b981cd815f31a8017cf3d1c5fa6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f975512d3180a87c61ed8c5fb7b4a49c95065239a5379779261e98dd749f5d"
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
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"
  end
end
