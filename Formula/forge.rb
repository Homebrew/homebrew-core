class Forge < Formula
  desc "High Performance Visualization"
  homepage "https://github.com/arrayfire/forge"
  url "https://github.com/arrayfire/forge/archive/v1.0.5.tar.gz"
  sha256 "4ed631cfde6a9c0daf786d68b47719edec024928b3e23dbfb2e786e60ab01097"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "af25416dba5b9b0ea4fd3cc26270a9ee9cd955d5f265e3b2e325dc89628be568" => :big_sur
    sha256 "d97b409d7830196f87123ef062672df3ccbea3363d6dce0e74c98e2e192b0c0a" => :catalina
    sha256 "239cd658c7042ab7591e1575ee80b09a6e74279276b7227ed2ad8a47907e6a84" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "glm"
  depends_on "libx11"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <forge.h>
      #include <iostream>

      int main()
      {
          std::cout << fg_err_to_string(FG_ERR_NONE) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lforge", "-o", "test"
    assert_match "Success", shell_output("./test")
  end
end
