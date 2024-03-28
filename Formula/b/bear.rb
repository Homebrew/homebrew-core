class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 16
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "86c5aa0077d6bf06b61505ca63491d59de0b7c17ba9ff3799e08ea83fc1a66a5"
    sha256 arm64_ventura:  "be13e35e58afb123d53f07de963b3b107531bfd15641de4bda07164e9f392d55"
    sha256 arm64_monterey: "ce990e2292a8a09d317515c7e9ad304e12a42472e12944501e0fba810f9076a0"
    sha256 sonoma:         "30f0754f4dae43e9eddb8f5e62886dda629cc8eb66edbb4e79ee8d9e1e42224c"
    sha256 ventura:        "7c3a619556d477c7a5e0dd090374a52180e339ffb1e370c5056a3d846f542716"
    sha256 monterey:       "50c1ba1f69b25fd07b5e655e0d9efdabc31f160a6c83501a04e6dc628730f3d5"
    sha256 x86_64_linux:   "2f3571f79a3fc51e253135057ec9236b6c6c6b5af8cf38f3eac4468641a6f490"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
