class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://github.com/JamesBoer/Jinx"
  url "https://github.com/JamesBoer/Jinx/archive/v1.1.8.tar.gz"
  sha256 "9388305d55e61cfb41eae1b50b0144668d39eb512d40af83efdfbccc1ab8ad1a"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git"

  depends_on "cmake" => :build

  def install
    # disable building tests
    inreplace "CMakeLists.txt", "if(NOT jinx_is_subproject)", "if(FALSE)"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "libJinx.a"
    end

    include.install Dir["Source/*.h"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "Jinx.h"

      int main() {
        // Create the Jinx runtime object
        auto runtime = Jinx::CreateRuntime();

        // Text containing our Jinx script
        const char * scriptText =
        u8R"(

        -- Use the core library
        import core

        -- Write to the debug output
        write line "Hello, world!"

        )";

        // Create and execute a script object
        auto script = runtime->ExecuteScript(scriptText);
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lJinx", "-o", "test"
    assert_match "Hello, world!", shell_output("./test")
  end
end
