class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://glbinding.org/"
  url "https://github.com/cginternals/glbinding/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "bb39a97d5d94f70fe6e9c2152e0d8d760758bb031b352e1707fa90f00a43fc69"
  license "MIT"
  head "https://github.com/cginternals/glbinding.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "762f8e6516a5a5738ccf12cd97375005bb6f740400b95d9716abee36a9b824d9"
    sha256 cellar: :any,                 arm64_sequoia: "6798ca9c08e9ccc59eab53d4665284e48f7f2a997bc519ec0d963c85a12f9db2"
    sha256 cellar: :any,                 arm64_sonoma:  "4f7d37307826d7a2109acd928b492a5ce909452d34b721580f83f44861875cc7"
    sha256 cellar: :any,                 arm64_ventura: "5b83488e93d023db298f1e2e045c6a330c1ac7324672b5766b368caeea00b7c5"
    sha256 cellar: :any,                 sonoma:        "63bf53958290dccffdb8ab55ceaf14491f10f2d8ab8e7225e56d3fa7f79f3c36"
    sha256 cellar: :any,                 ventura:       "1f7649a5e986c147c1d290c72e1b79d91168266bbba58be9b1005880885293ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4419c9275044ca9857a4208c2777c100aa6288e7b14febf2d8beab924233a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add170cb3bec049265b779eb0bb602dd60d83d011887efdb21c8d47406a75c78"
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
