class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://glbinding.org/"
  url "https://github.com/cginternals/glbinding/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "0f623f9eb924d9e24124fd014c877405560f8864a4a1f9b1f92a160dfa32f816"
  license "MIT"
  head "https://github.com/cginternals/glbinding.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4109c5d9acda5a3ce82a95263df048f628f5b3e24d17c1d44976adcd7e9c107f"
    sha256 cellar: :any,                 arm64_sonoma:  "942d58c6c3c85b40bfd76fe28f6af2f1eee8187d3fcc5793967f2a2994088c83"
    sha256 cellar: :any,                 arm64_ventura: "80ad1e314eae1f15e047171937706be2c8b1c24ee0c13c5783ff0de9379ef65b"
    sha256 cellar: :any,                 sonoma:        "747d1af15a6de6ede43500d8ce09e948171a76dd7510212266758113fc9db7d8"
    sha256 cellar: :any,                 ventura:       "368d764b4ef7eaa96bc7bee68676c778f0ececd3cc2b33d242293b3d31cde21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9f6a2969d63421f0408fc21564656a9fc9f761d127816cf45d7057e06901b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ecd120e2f945bf4c912fa08ddea6ff94225c38dc31b921363e4889361410db"
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

    # support cmake 4 build, upstream pr ref, https://github.com/cginternals/glbinding/pull/356
    inreplace ["CMakeLists.txt", "source/tests/CMakeLists.txt"] do |f|
      f.gsub! "cmake_minimum_required(VERSION 3.0", "cmake_minimum_required(VERSION 3.5"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DOPTION_BUILD_OWN_KHR_HEADERS=#{OS.mac? ? "ON" : "OFF"}",
                    "-DEXECUTABLE_INSTALL_RPATH=#{rpath}",
                    "-DLIBRARY_INSTALL_RPATH=#{loader_path}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glbinding/gl/gl.h>
      #include <glbinding/glbinding.h>
      #include <GLFW/glfw3.h>
      int main(void)
      {
        glbinding::initialize(glfwGetProcAddress);
      }
    CPP
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
