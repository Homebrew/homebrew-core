class Lager < Formula
  desc "C++ lib for value-oriented design using unidirectional data-flow architecture"
  homepage "https://sinusoid.es/lager/"
  url "https://github.com/arximboldi/lager/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9e4743c3fe2c95c1653c3fd088a2200108f09d758725697831852dc91d15d174"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, ventura:        "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, monterey:       "cc095435132c064037c0cd2da9fb6ea76bfff6d8e2b57e68845f0026e7e8afe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ed225918215d18f941fde3c5d49197caa83c78b9eed0511d35e8e8fd059366"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "zug"

  def install
    args = %w[
      -Dlager_BUILD_DEBUGGER_EXAMPLES=OFF
      -Dlager_BUILD_EXAMPLES=OFF
      -Dlager_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args.reject { |s| s["-DBUILD_TESTING=OFF"] }
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <lager/state.hpp>
      #include <string>

      int main() {
        using model = int;

        auto state = lager::make_state(model{});
        std::cout << state.get() << std::endl; // 0
        state.set(1);
        std::cout << state.get() << std::endl; // 0
        lager::commit(state);
        std::cout << state.get() << std::endl; // 1

        auto state2 = lager::make_state(model{}, lager::automatic_tag{});
        state2.set(2);
        std::cout << state2.get() << std::endl; // 2
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
