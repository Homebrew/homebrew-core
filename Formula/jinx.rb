class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://github.com/JamesBoer/Jinx"
  url "https://github.com/JamesBoer/Jinx/archive/v1.3.9.tar.gz"
  sha256 "ea724319c902405eb16db3acdf6a31813c2bfd20e8312c1ade3d751ad8adc2ea"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa958ceb295710e0aabf7ddd0d8aa420f86d9c9cd372a37fa0603cf3fd9c2fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f50d2c1d7fa7d03e33af0d5097d0635d3e7c04908a611ba201b5f3ffe7322b65"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb1cf1d04dce70ebb4d8210f8db913c7706fb211d4b238109d4400f00e78ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d5b18b26a2f879770dfdaaca8da4f81e6a2d0cfbdcb900dd540d3f731f69382"
    sha256 cellar: :any_skip_relocation, catalina:       "9137f44de3bb8fa31baf1e27a7f2eef193434dfb1dfe8cfaf0c6baccc497d257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d9efcb7f4b4d22ff447c507d26deb3474cf9fed049461712d76690bd9b05bc"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
