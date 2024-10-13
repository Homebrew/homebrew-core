class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern/cling/"
  url "https://github.com/root-project/cling/archive/refs/tags/v1.1.tar.gz"
  sha256 "e8b33b5e99c6267a85be71fc6eb8e5622ce8aee864c60587cb71f43c27e97032"
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
    sha256 arm64_sequoia:  "08656cf9226092658a6151287f836f4f9a954ba10aa4a260e24196b94a0691fc"
    sha256 arm64_sonoma:   "19b0412143d83a482fd5252d3a5a298ad5867f187f750a260be09be6889d31d2"
    sha256 arm64_ventura:  "ac3b9dd399d88c74c4c3c0b88edc49ededd1922fd1cf1f03c23bed338697765d"
    sha256 arm64_monterey: "6cf7a996760a1f5e5d79e5cbf4f258754c4d999691b74fdf37ab36629a0bce8b"
    sha256 sonoma:         "cda39b9bbadc8473dce97cc997ba974630cdd80774f9ff78cccf5dfa9738a3a8"
    sha256 ventura:        "c3ae49562e7dce88ff71708a1fac0813347f374d27b7f4afe3be1570271a61fa"
    sha256 monterey:       "9462386c62c760c5826399df87f677f99ecc238348421230ec95032dad3ae0e7"
    sha256 x86_64_linux:   "75a5918cdc9831cf4e42d32ab616fdcc95ca5a5e734273b12d7671385d063a09"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # https://github.com/root-project/cling?tab=readme-ov-file#building-from-source
  # grab the latest tag from cling-latest branch
  resource "llvm" do
    url "https://github.com/root-project/llvm-project/archive/refs/tags/cling-llvm16-20240621-02.tar.gz"
    sha256 "51bcf665422be228fbc730cac8bd6bd78258fab80de97c90f629411f14021243"
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
