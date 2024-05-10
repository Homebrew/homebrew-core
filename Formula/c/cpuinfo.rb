class Cpuinfo < Formula
  desc "CPU INFOrmation library and associated command-line tools"
  homepage "https://github.com/pytorch/cpuinfo"
  url "https://github.com/pytorch/cpuinfo/archive/3c8b1533ac03dd6531ab6e7b9245d488f13a82a5.tar.gz"
  sha256 "87fc79472eb30b734cbe700dfe3edc0bdb96c33e3ce44e48ab327bbd8783f07f"
  license "BSD-2-Clause"
  head "https://github.com/pytorch/cpuinfo.git", branch: "main"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    # These are unnecessary, and avoid the Google Test dependency:
                    "-DCPUINFO_BUILD_MOCK_TESTS=OFF",
                    "-DCPUINFO_BUILD_UNIT_TESTS=OFF",
                    # Remaining build options were chimped from Debian:
                    # https://salsa.debian.org/deeplearning-team/cpuinfo/-/blob/56b503e9/debian/rules#L9-13
                    "-DCPUINFO_BUILD_BENCHMARKS=OFF",
                    "-DCPUINFO_LIBRARY_TYPE=shared",
                    "-DCPUINFO_LOG_LEVEL=error",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      The associated command-line tools are named 'cpu-info', 'cache-info', and 'isa-info'.
      On applicable architectures, 'gpu-dump', 'auxv-dump', 'cpuid-dump', and 'cpuinfo-dump'
      are also installed.
    EOS
  end

  test do
    assert_match "Cores:", shell_output("#{bin}/cpu-info 2>&1")
    assert_match "cache:", shell_output("#{bin}/cache-info 2>&1")
    if Hardware::CPU.intel?
      assert_match "Scalar instructions:", shell_output("#{bin}/isa-info 2>&1")
    elsif Hardware::CPU.arm?
      assert_match "Instruction sets:", shell_output("#{bin}/isa-info 2>&1")
    end
  end
end
