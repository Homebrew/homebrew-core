class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://github.com/JamesBoer/Jinx"
  url "https://github.com/JamesBoer/Jinx/archive/v1.3.9.tar.gz"
  sha256 "ea724319c902405eb16db3acdf6a31813c2bfd20e8312c1ade3d751ad8adc2ea"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d860754de69cd9d21e3c09e17e95de5f6e788280d821604a665f0caac7b44e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a0bbf1aabba2dc324df0900386ad1e3c75f8ec10a61374e23a3ccf16d442a80"
    sha256 cellar: :any_skip_relocation, monterey:       "07ab4faca2d623a0184edefa4025b099241cb59d257d4c9f1abff32e0aadb1f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9b426b226f2fc1388a52d97acfc55780baf6c7e4f148ce8e114b3a50f453ec"
    sha256 cellar: :any_skip_relocation, catalina:       "3de90aa148fad5638d83f7214e30aa8a51c7b8c216ed8ce6cce5998be1fd71ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9985239e95b1b0bb0960948ec9f68263ebf0e53a1954c464674ddbfd4040ef"
  end

  depends_on "cmake" => :build

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
