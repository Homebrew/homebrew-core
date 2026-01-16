class Lager < Formula
  desc "C++ lib for value-oriented design using unidirectional data-flow architecture"
  homepage "https://sinusoid.es/lager/"
  url "https://github.com/arximboldi/lager/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "026e12a86214e7a2c24477a307c82240f07dcc65b53b68763b7b408c43d5d2cb"
  license "MIT"
  head "https://github.com/arximboldi/lager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebbb63b2e8a33ba657c94b3e3cf14879d196bc909805a3a507b75739ee145e83"
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
