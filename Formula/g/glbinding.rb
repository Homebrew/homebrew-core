class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "a0aa5e67b538649979a71705313fc2b2c3aa49cf9af62a97f7ee9a665fd30564"
  license "MIT"
  head "https://github.com/cginternals/glbinding.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "80956bf8a0370c6264bd39643f4eafb464b709fc4424f704271b709e3c5656b6"
    sha256 cellar: :any,                 arm64_ventura:  "c9e26b3581c3e61c4ce3b18106e0d9fc2a92c1770822c3a93fcaad76fd3e7fcf"
    sha256 cellar: :any,                 arm64_monterey: "785ae1ae8e1aee4cf8dcd8843ed7e105d1c354d555c2819efba3756bc6b41a56"
    sha256 cellar: :any,                 sonoma:         "9db31e60950241feb36d36d5cdda92031e3eb66b547e2e00f9c53d487a918bf6"
    sha256 cellar: :any,                 ventura:        "1499185669c882d9710c890a6448296ad79586ab0a7975fa6e496d083285e841"
    sha256 cellar: :any,                 monterey:       "b902b69d802b33e8d7448c97fbd07d914d1075b28f6fba80bbaf56e7ebe0d9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ac8e1d61c4806679d2d8cb4d305a8a62573db5ed6ff96b2fc0a4cc4dff567e"
  end

  depends_on "cmake" => :build
  depends_on "glfw" => :test

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Force install to use system directory structure as the upstream only
    # considers /usr and /usr/local to be valid for a system installation
    inreplace "CMakeLists.txt", "set(SYSTEM_DIR_INSTALL FALSE)", "set(SYSTEM_DIR_INSTALL TRUE)"

    system "cmake", "-S", ".", "-B", "build",
                    "-DOPTION_BUILD_OWN_KHR_HEADERS=#{OS.mac? ? "ON" : "OFF"}",
                    "-DEXECUTABLE_INSTALL_RPATH=#{rpath}",
                    "-DLIBRARY_INSTALL_RPATH=#{loader_path}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/glbinding.h>
      #include <GLFW/glfw3.h>
      int main(void)
      {
        glbinding::initialize(glfwGetProcAddress);
      }
    EOS
    open_gl = if OS.mac?
      ["-I#{include}/glbinding/3rdparty", "-framework", "OpenGL"]
    else
      ["-L#{Formula["mesa-glu"].lib}", "-lGL"]
    end
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", *open_gl,
                    "-L#{lib}", "-lglbinding", "-L#{Formula["glfw"].opt_lib}", "-lglfw",
                    *ENV.cflags.to_s.split
    system "./test"
  end
end
