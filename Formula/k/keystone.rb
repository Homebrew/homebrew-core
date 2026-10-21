class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://github.com/keystone-engine/keystone"
  url "https://github.com/keystone-engine/keystone/archive/refs/tags/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0-only" # with FOSS License Exception (non-SPDX, see EXCEPTIONS-CLIENT)
  revision 1
  head "https://github.com/keystone-engine/keystone.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "778ca2c22d2f7f31fe852406e0b843f337dd6339120e00b2ace28cece0ea6c6a"
    sha256 cellar: :any, arm64_tahoe:       "6fdcb3473e6ef6e69c13deb8493faf16ef5b5fcf78487b1bef9d601ad10c2de9"
    sha256 cellar: :any, arm64_sequoia:     "93f04ae45bc858856ae22ed8dcffa6cb8c946b24a134458a3f4e983cb076ca42"
    sha256 cellar: :any, arm64_linux:       "f9d4e84a59e2d4923efccbf64fdc082963917c8e5789c3ee946974d50fdc9278"
    sha256 cellar: :any, x86_64_linux:      "924a3a69cb37cf2300fac52336f07c48b688bfdea23403bad9703b38797ddc81"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15" => :build

  deny_network_access!

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
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
