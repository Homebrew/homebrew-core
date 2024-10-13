class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.3/coin-4.0.3-src.tar.gz"
    sha256 "66e3f381401f98d789154eb00b2996984da95bc401ee69cc77d2a72ed86dfda8"

    resource "soqt" do
      url "https://github.com/coin3d/soqt/releases/download/v1.6.2/soqt-1.6.2-src.tar.gz"
      sha256 "fb483b20015ab827ba46eb090bd7be5bc2f3d0349c2f947c3089af2b7003869c"
    end

    # We use the pre-release to support `pyside` and `python@3.12`.
    # This matches Arch Linux[^1] and Debian[^2] packages.
    #
    # [^1]: https://archlinux.org/packages/extra/x86_64/python-pivy/
    # [^2]: https://packages.debian.org/trixie/python3-pivy
    resource "pivy" do
      url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.9.a0.tar.gz"
      sha256 "2c2da80ae216fe06394562f4a8fc081179d678f20bf6f8ec412cda470d7eeb91"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "07ba0c39b01b9fcd22fb91035e9611bec4963639866f3087dfab514a179c085c"
    sha256 cellar: :any, arm64_ventura:  "ba7c7fed04fff40f0abb513edaa5f94991082831790cda8568534ecec152f6e3"
    sha256 cellar: :any, arm64_monterey: "36609cc09227ad57193fcac9f3f985cd6dc63ed88db22064558dfff8ad787305"
    sha256 cellar: :any, sonoma:         "aed55516747e173e91ba4f54613c545b0bd2eb56e166cfa8713dec27189b2939"
    sha256 cellar: :any, ventura:        "c2b9e8a6316316b8be599e29339d52a34e2c0cbcfc4e6a49f763f7f5c0b8182b"
    sha256 cellar: :any, monterey:       "112eb4cf91392b07c62c1dc69212f7845d5ef8f685c2d2cbd9419527779ed203"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "soqt" do
      url "https://github.com/coin3d/soqt.git", branch: "master"
    end

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside"
  depends_on "python@3.12"
  depends_on "qt"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.12"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
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

    resource("pivy").stage do
      # Allow setup.py to build with Qt6 as we saw some issues using CMake directly on Intel
      inreplace "distutils_cmake/CMakeLists.txt", " NONE)", ")" # allow languages
      ENV.append "CXXFLAGS", "-std=c++17"

      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-Wl,-rpath,#{opt_lib}"
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"

    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system python3, "-c", <<~EOS
      import shiboken6
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end
