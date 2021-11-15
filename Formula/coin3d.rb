class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]
  revision 1

  stable do
    url "https://github.com/coin3d/coin/archive/Coin-4.0.0.tar.gz"
    sha256 "b00d2a8e9d962397cf9bf0d9baa81bcecfbd16eef675a98c792f5cf49eb6e805"

    resource "pivy" do
      url "https://github.com/coin3d/pivy/archive/0.6.5.tar.gz"
      sha256 "16f2e339e5c59a6438266abe491013a20f53267e596850efad1559564a2c1719"
    end
  end

  livecheck do
    url :stable
    regex(/^Coin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "cb3d9a2625bc3dc1991c54ad642121966666a84c211d16bac340c42fda93b12e"
    sha256               arm64_big_sur:  "6d8bb0e053410225f3d83a4457d0b2a7582b1551035ee792c8fead40a80cf044"
    sha256               big_sur:        "74fc8c889f099dd649513d06609990b9012ba96036dcde2f465f75ba8e8c7ba3"
    sha256               catalina:       "8be84b25f7f685bdae957607ab4e1aa37095f32eb5614fc9979399a6ab990705"
    sha256               mojave:         "07a8e2f4807dbcc411cba20a7b7b5696be3648303f2f0636e7075fd155b7b902"
  end

  head do
    url "https://github.com/coin3d/coin.git"

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside@2"
  depends_on "python@3.9"

  def install
    # Create an empty directory for cpack to make the build system
    # happy. This is a workaround for a build issue on upstream that
    # was fixed by commit be8e3d57aeb5b4df6abb52c5fa88666d48e7d7a0 but
    # hasn't made it to a release yet.
    mkdir "cpack.d" do
      touch "CMakeLists.txt"
    end

    mkdir "cmakebuild" do
      args = std_cmake_args + %w[
        -GNinja
        -DCOIN_BUILD_MAC_FRAMEWORK=OFF
        -DCOIN_BUILD_DOCUMENTATION=ON
        -DCOIN_BUILD_TESTS=OFF
      ]

      system "cmake", "..", *args
      system "ninja", "install"
    end

    resource("pivy").stage do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-rpath #{opt_lib}"
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(prefix)
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", "-Wl,-framework,OpenGL", \
           "-o", "test"
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["pyside@2"].opt_lib}/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end
