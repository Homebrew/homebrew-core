class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://github.com/keystone-engine/keystone"
  url "https://github.com/keystone-engine/keystone/archive/refs/tags/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/keystone-engine/keystone.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "792e2f64e52c56b737ffa463eebbc8c69912b6528c0aa6094b1547417bdafb64"
    sha256 cellar: :any,                 arm64_sequoia: "0a34a8cc81909cd75cb20bc2573a3a5d1328f4b3ac44e8a814d3da9dff59a7d7"
    sha256 cellar: :any,                 arm64_sonoma:  "7f16a69f3cafa919b46840c4dff01d6f7220167499c0dcc22c972738a6b3c7fb"
    sha256 cellar: :any,                 sonoma:        "5777578985ee84ccba4730e20677576c9024ad0a86c0f49546344a232e9413ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78641458d84848c32803626ba0127081539d768e284ccfa262baa48265e4cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f985a7993b44fba4ca497a76488ce22eaa4ac77de292fccf716c4d5e9acca7"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build

  def python
    which("python3.14")
  end

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{python}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    # Workaround to build with CMake 4
    inreplace %w[CMakeLists.txt llvm/CMakeLists.txt],
              "cmake_policy(SET CMP0051 OLD)", ""
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    # Build shared library
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "static"
    lib.install "static/llvm/lib/libkeystone.a"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
