class Imgui < Formula
  desc "Bloat-free Graphical User interface for C++ with minimal dependencies"
  homepage "https://dearimgui.com"
  url "https://github.com/ocornut/imgui/archive/refs/tags/v1.91.5.tar.gz"
  sha256 "2aa2d169c569368439e5d5667e0796d09ca5cc6432965ce082e516937d7db254"
  license "MIT"
  head "https://github.com/ocornut/imgui.git", branch: "master"

  depends_on "gcc" => :build

  def install
    system ENV.cxx, "-std=c++11", "-c", "-fpic", "imgui.cpp"
    system ENV.cxx, "-std=c++11", "-c", "-fpic", "imgui_demo.cpp"
    system ENV.cxx, "-std=c++11", "-c", "-fpic", "imgui_draw.cpp"
    system ENV.cxx, "-std=c++11", "-c", "-fpic", "imgui_tables.cpp"
    system ENV.cxx, "-std=c++11", "-c", "-fpic", "imgui_widgets.cpp"

    system ENV.cxx, "-std=c++11", "-shared", "-o", "libimgui.so", \
    "imgui.o", "imgui_demo.o", "imgui_draw.o", "imgui_tables.o", "imgui_widgets.o"

    lib.install "libimgui.so"
    include.install "imgui.h", "imconfig.h", "imgui_internal.h"
  end

  test do
    (testpath/"test.cpp").write <<~C
      #include <imgui.h>
      int main() {
        ImGui::CreateContext();
        ImGui::DestroyContext();
        return 0;
      }
    C
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-limgui"
    system "./test"
  end
end
