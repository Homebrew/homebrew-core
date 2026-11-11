class DbgMacro < Formula
  desc "Dbg(…) macro for C++"
  homepage "https://github.com/sharkdp/dbg-macro"
  url "https://github.com/sharkdp/dbg-macro/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "fffea75f067c69995853dc790626887788e2c4c9eb0a5a0014a4501d2b6b9909"
  license "MIT"
  head "https://github.com/sharkdp/dbg-macro.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c3b797e721c386d0f07439cb9d8cfa7617f467e1e577aa8bda1127094c08e87e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DCATCH_BUILD_TESTING=OFF
      -DDBG_MACRO_ENABLE_TESTS=OFF
    ]

    # CMake 4.x compatibility
    # https://github.com/sharkdp/dbg-macro/commit/aeca93c064792c38ababe0128372cf6d3387466b.patch?full_index=1
    # TODO: remove in the next release
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" if build.stable?

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dbg.h>
      int main() {
        dbg(42, "hello world", false);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
