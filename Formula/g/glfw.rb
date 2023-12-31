class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/refs/tags/3.3.9.tar.gz"
  sha256 "a7e7faef424fcb5f83d8faecf9d697a338da7f7a906fc1afbc0e1879ef31bd53"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a57c82ca524c088bfe769b0c82a117723b808d0c6f12ed58142623c7d49c885b"
    sha256 cellar: :any,                 arm64_ventura:  "b8be90143734ec60dba41c54002de776d88cef22f9cbd6bbbb5ff62c2a157247"
    sha256 cellar: :any,                 arm64_monterey: "0977c638c0f0e778e98ef26708100dd3615976090f6a24b7601ea0f8f5710d26"
    sha256 cellar: :any,                 sonoma:         "3f7b8f7cb5504c67686430ace522917ffdcd23133bc507d5b626ab11cf7b06fb"
    sha256 cellar: :any,                 ventura:        "df455405d14c30aa1f5db93eab3084e011bb113bd6a241a44f996d72e9570184"
    sha256 cellar: :any,                 monterey:       "26ece97f71aa7e287e532307d4d54baf569f9a25704cb67cd18e9b5f5e07d3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95b38b2877d6f826767c69c3bd841187665af7cf9f8a5a225215db44669d72a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
