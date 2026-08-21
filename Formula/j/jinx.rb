class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://jamesboer.github.io/Jinx/"
  url "https://github.com/JamesBoer/Jinx/archive/refs/tags/v1.3.11.tar.gz"
  sha256 "58ca494e965b799e7296c4dc98936230fdc97f0072e78d6f658c976c0cfaa6f5"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc5434d37d64392eb574ee23426475ea0df694f3bfea7d6285d542a0d14bb18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed166bb0ff6914dfc6931071644bf791685ac3f0d1bf2596d6ee141de9780b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca58b6d5a3a9139692f334fa40be5d49f38fae4031c5b556560a7dec31a92280"
    sha256 cellar: :any_skip_relocation, sonoma:        "822b1bf6be6d18282fcb87789a99e85ba6abb33e75ee2a2862434216f31b8693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2339505a2b5f2308587803abbfd86c8504927d4dbedbde58ba46e9b09e17cede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00dceb0a22d7db55452a66ca2d1914a811a5d5ff8bfb00896c023f03a153a63"
  end

  depends_on "cmake" => :build

  def install
    # disable building tests
    inreplace "CMakeLists.txt", "if(NOT jinx_is_subproject)", "if(FALSE)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "build/libJinx.a"

    include.install Dir["Source/*.h"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lJinx", "-o", "test"
    assert_match "Hello, world!", shell_output("./test")
  end
end
