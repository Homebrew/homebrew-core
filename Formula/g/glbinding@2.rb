class GlbindingAT2 < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://glbinding.org/"
  url "https://github.com/cginternals/glbinding/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "cb5971b086c0d217b2304d31368803fd2b8c12ee0d41c280d40d7c23588f8be2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6dddc516878a360ff4c3204f6dbff543c7480ca9a636206f1db433de4af442a5"
    sha256 cellar: :any,                 arm64_sequoia:  "05fe3756c9e2f1a9efec689a64cbc3d55c7d00831af9d19411f9572b71ca81c4"
    sha256 cellar: :any,                 arm64_sonoma:   "53bd1ac2798e131aa19966dbd5ff886f4614a020e20c1804dad580f018f2d0b4"
    sha256 cellar: :any,                 arm64_ventura:  "7b509031915859038fbc43e27ea66fbf7b7448f0169cb8f1c10931499924314a"
    sha256 cellar: :any,                 arm64_monterey: "a71c860331ba72a181b2b3d124ce21919ae28df45490806af7cfeac6e11e60b6"
    sha256 cellar: :any,                 sonoma:         "f3b925f4e2eada4a1c18e8bdf6506227bbf884141c5e21098450974838745633"
    sha256 cellar: :any,                 ventura:        "004e4f718650c5f8204a1690b03b67fdb1b29aaf1aa8ee50835c0d82d695e7f3"
    sha256 cellar: :any,                 monterey:       "9b1ae7f55a826ba144b346a769c1a417a8c4be0252a8fe66aaab68aa332ac68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "61a0c29c4f4d29510e0737c374c85a42eed6da3504510c8107ab578e770e59eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28aa58dd696d850b91f8e6552e8b23389c0c437be19319c6939d3b7e52265dc3"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Force install to use system directory structure as the upstream only
    # considers /usr and /usr/local to be valid for a system installation
    inreplace "CMakeLists.txt", "set(SYSTEM_DIR_INSTALL FALSE)", "set(SYSTEM_DIR_INSTALL TRUE)"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_GPU_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
    CPP
    open_gl = OS.mac? ? ["-framework", "OpenGL"] : ["-L#{Formula["mesa-glu"].lib}", "-lGL"]
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}", *open_gl,
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
