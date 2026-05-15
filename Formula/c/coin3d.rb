class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.8/coin-4.0.8-src.tar.gz"
    sha256 "aff6c7edf24cfb935edba46574ec5f83b543c47ff79e40c21fb92dc709b0f2c4"

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
    sha256 cellar: :any,                 arm64_tahoe:   "c99f420721e92e91139456224982baac1eb95863a36880bcff3d7892f96dc777"
    sha256 cellar: :any,                 arm64_sequoia: "e370d24b0e20aff5f37a7ddfa10cd4b262661863172f3a76d437e73b24ef9875"
    sha256 cellar: :any,                 arm64_sonoma:  "45e831f7434645b2eb8ac03b66088fe24aec3792abe5ccf6cf08ddb81fca624c"
    sha256 cellar: :any,                 sonoma:        "c97ccb81514a19c8e18fb1144e60cde5e9cb6979e2a0eb11a62030dc647073fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75155d00c26b9df819b006d8a4b0abfbeda5fffbde5f4dbc8ad09bedcc52b4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44311b6e8b687dcd7010a3aac45c37ee96f50586a0283712cb23405771e1582"
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
