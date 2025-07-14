class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.4/coin-4.0.4-src.tar.gz"
    sha256 "80efd056a445050939a265db307d106ac7524105774d4be924a71b0cff23a719"

    resource "soqt" do
      url "https://github.com/coin3d/soqt/releases/download/v1.6.3/soqt-1.6.3-src.tar.gz"
      sha256 "79342e89290783457c075fb6a60088aad4a48ea072ede06fdf01985075ef46bd"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "1d0a00f874475b39591d10cb9547a4b71d02524c668775a3fa3c9f2aeb514fd2"
    sha256 cellar: :any,                 arm64_ventura: "ba81941b962638fa968defb6b0420cd2067b2080a5ce68ec3b5a68270287961e"
    sha256 cellar: :any,                 sonoma:        "8632b7925921ce935bd7030420a270f374be62d58ec2b50dab44b1caa1ab2177"
    sha256 cellar: :any,                 ventura:       "4a4e57dfa965415f26fd8757f2358a8ca660070d647f63409e41caf0dd8832cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2572d61c237d74bc32c4c645b29720611eca19e8ae4528711a61acc910d32a95"
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
  depends_on "qt"

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
    odie "Remove cmake 4 build patch" if build.stable? && resource("soqt").version > "1.6.3"
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
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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
