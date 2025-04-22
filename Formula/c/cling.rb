class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern/cling/"
  url "https://github.com/root-project/cling/archive/refs/tags/v1.2.tar.gz"
  sha256 "beee8e461424d267ee2dec88b3de57326bc8e3470b4ceae2744de7d3d3aba1eb"
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
    sha256 arm64_sequoia: "2180b446aa9cee44f570e641dd6ec247844271c9113f44e5669d743cf7b90e4f"
    sha256 arm64_sonoma:  "b50cf5b6af8e38837eb7cbe80ddc5972e4b7574b7631129dd58ab74a36d1426f"
    sha256 arm64_ventura: "63a6979bd28f2e05a9a4639f7d5eeec99268be12af84074bf5afe731c63537a5"
    sha256 sonoma:        "616917ec942914038178ab9c18baf11f09adb518fd09a1bc453d8c570d87303e"
    sha256 ventura:       "2e72a1bb7d132bfd0d3630d7d556b04ad7440bab3c6ce4ba6b9a1feb823bc81e"
    sha256 arm64_linux:   "a8e84114fbe1eb79d64b4eb40107f97bdaf8820bde24dce48adb47c47d95e18d"
    sha256 x86_64_linux:  "0babe63deefb1727a2da1fcb90c9c95a296a04317cb87ccd923f652f8b034121"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # https://github.com/root-project/cling?tab=readme-ov-file#building-from-source
  # `git ls-remote --heads https://github.com/root-project/llvm-project.git cling-latest`
  # grab the latest tag https://github.com/root-project/llvm-project/commit/<commit>
  resource "llvm" do
    url "https://github.com/root-project/llvm-project/archive/refs/tags/cling-llvm18-20240821-01.tar.gz"
    sha256 "47676c77bfa7c63cd6101bcea2611ac0cf363cb5ceb87955ea9e2b3e832ea887"
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
