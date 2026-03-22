class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern/cling/"
  url "https://github.com/root-project/cling/archive/refs/tags/v1.3.tar.gz"
  sha256 "ca81f3bc952338beffba178633d77f5b3e1f1f180cbe2bb9f2713c06f410fd18"
  license all_of: [
    { any_of: ["LGPL-2.1-only", "NCSA"] },
    { "Apache-2.0" => { with: "LLVM-exception" } }, # llvm
  ]

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a0e982f092f47c906adcc71ff75b127822ecfab69cc40d353955a007682e4cf1"
    sha256 arm64_sequoia: "77bd4ae3b0df3f1a2ac6b89b97653e5b77539f8704b5cbe3fa069f2e0b86fb1d"
    sha256 arm64_sonoma:  "ca6edc3940448d844e33400c80631bead2c2be135af68c9305f9b720f31d8103"
    sha256 sonoma:        "f0c5153fa13c8f5194047a799cb51f44e66bab25dadfea0486363f72194ee810"
    sha256 arm64_linux:   "4a99d40bb84f2cc6986094d0e9c89e73fe34aa5df810a3408a56dc8ff2d00208"
    sha256 x86_64_linux:  "7072596311dacb08ab7bddb2e7d4d12496c6525ba44981f3e9d2973f97c5fdba"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # https://github.com/root-project/cling?tab=readme-ov-file#building-from-source
  # `git ls-remote --heads https://github.com/root-project/llvm-project.git cling-latest`
  # grab the latest tag https://github.com/root-project/llvm-project/commit/<commit>
  resource "llvm" do
    url "https://github.com/root-project/llvm-project/archive/refs/tags/cling-llvm20-20260119-01.tar.gz"
    sha256 "6d023a311393eee6025bf3b1e6bb9caa9b31ec2f288f9bee1a2fbe71072b2849"
  end

  def install
    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https://github.com/Homebrew/homebrew-core/issues/135714
    # Related: https://github.com/root-project/cling/issues/457
    inreplace "lib/Interpreter/CMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'

    (buildpath/"llvm").install resource("llvm")

    system "cmake", "-S", "llvm/llvm", "-B", "build",
                    "-DCLING_CXX_PATH=clang++",
                    "-DLLVM_BUILD_TOOLS=OFF",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=#{buildpath}",
                    "-DLLVM_EXTERNAL_PROJECTS=cling",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    "-DLLVM_TARGETS_TO_BUILD=host;NVPTX",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # We use an exec script as a symlink causes issues finding headers
    bin.write_exec_script libexec/"bin/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
