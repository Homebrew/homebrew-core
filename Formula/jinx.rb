class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://github.com/JamesBoer/Jinx"
  url "https://github.com/JamesBoer/Jinx/archive/v1.2.0.tar.gz"
  sha256 "18a88ef34b06c63210ac966429785c5e6f7ec4369719260f2af4a3dee1544e1b"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "752063badf7173acdc233d96ae8b2eb4f84897e2dd83f29c56a86aa52f728056" => :big_sur
    sha256 "b91d30facce35e18f79655ab8ce200e413d63175e520d45e5c7276383dfcaea9" => :arm64_big_sur
    sha256 "0500e01d366b1f61c140570eeaae54003e30ad139b3f169d7dafdb08b2fd7b59" => :catalina
    sha256 "f12580f7319652bf5309ef767509d2f2c823bbedadeb8a85b2b6f35d0a65a747" => :mojave
    sha256 "22146d4fcd750935d4f125820ee3cb33088a977106fa630e22c7487e3a3a8132" => :high_sierra
  end

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
