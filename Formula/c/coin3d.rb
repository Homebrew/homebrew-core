class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.7/coin-4.0.7-src.tar.gz"
    sha256 "a01276052c31e84e4a069ee4452eab3b65a7d101a3fd7a09803be59125616270"

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
    sha256 cellar: :any,                 arm64_tahoe:   "49443d09f0467d12e81c022f986b92c6c2ea98aed128e2c04d7343b4b089734e"
    sha256 cellar: :any,                 arm64_sequoia: "df83d5cf0449dec342406f9d66d5413fac738b1f188fb662da43f037d46510d5"
    sha256 cellar: :any,                 arm64_sonoma:  "a9f49771924fc09d2fea2471bfa26ce75eb575f1f6de875cff005cf787a50950"
    sha256 cellar: :any,                 sonoma:        "bdd27ec1686977865494c754219a9d0c8e15fd3edea4d3e4097de330fb40b3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297309b6aafc080387697d01842df94757b58000c84b4ef00ea8a1ee44437cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd152688f979fb8d5f33f635d51ea71a887fabada4ae949bd9280590d77815b"
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
