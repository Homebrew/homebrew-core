class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  license "NCSA"
  revision 2

  stable do
    # TODO: Check if we can use unversioned `llvm` at version bump.
    url "https://include-what-you-use.org/downloads/include-what-you-use-0.20.src.tar.gz"
    sha256 "75fce1e6485f280f8f13f4c2d090b11d2fd2102b50857507c8413a919b7af899"
    depends_on "llvm@16"
  end

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https://include-what-you-use.org/downloads/"
    regex(/href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef8f37cc8f4eebacb2b5d00cf63f45697a7766920cfad74ac9ed9c4a2b053723"
    sha256 cellar: :any,                 arm64_ventura:  "0afd0990d819a2568df41c17f085d9b160230bee5574a6033602296a9e188ded"
    sha256 cellar: :any,                 arm64_monterey: "843aef80aacd7d951c74263a2f4c521114e0a52f8f95514c4ebda405e0eaa1f4"
    sha256 cellar: :any,                 arm64_big_sur:  "27ac00895576941fb13b3caa6d0d1f6a464c0a0ebcc240feefece53e8cf382de"
    sha256 cellar: :any,                 sonoma:         "062d2677974e4dd52eba2904339b0260606632cb4c1e5bfc9f42a4e499afb919"
    sha256 cellar: :any,                 ventura:        "ddfce96e790ca3b1c6482159148725f8fa9ee058cbdffd405d53aa1bfcd13df6"
    sha256 cellar: :any,                 monterey:       "30badd3f3516e107b32f22eae3dc47750e0d748095a797b7d2d5a59c84506e43"
    sha256 cellar: :any,                 big_sur:        "34834940add5003d4495185c6f4108ab83c0adf85b2cd30a2d5f8b459a6f2201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7abdfa312fab71542b757c034cd5617c99898d12f4cc5c7ce0e5e1d9b24c6e"
  end

  head do
    url "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
  end

  def install
    # FIXME: CMake stripped out our `llvm` rpath; work around that.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: libexec/"bin", target: llvm.opt_lib)}
    ]

    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec), *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script libexec.glob("bin/*")
    man1.install_symlink libexec.glob("share/man/man1/*")

    # include-what-you-use needs a copy of the clang and libc++ headers to be
    # located in specific folders under its resource path. These may need to be
    # updated when new major versions of llvm are released, i.e., by
    # incrementing the version of include-what-you-use or the revision of this
    # formula. This would be indicated by include-what-you-use failing to
    # locate stddef.h and/or stdlib.h when running the test block below.
    # https://clang.llvm.org/docs/LibTooling.html#libtooling-builtin-includes
    (libexec/"lib").mkpath
    ln_sf (llvm.opt_lib/"clang").relative_path_from(libexec/"lib"), libexec/"lib"
    (libexec/"include").mkpath
    ln_sf (llvm.opt_include/"c++").relative_path_from(libexec/"include"), libexec/"include"
  end

  test do
    (testpath/"direct.h").write <<~EOS
      #include <stddef.h>
      size_t function() { return (size_t)0; }
    EOS
    (testpath/"indirect.h").write <<~EOS
      #include "direct.h"
    EOS
    (testpath/"main.c").write <<~EOS
      #include "indirect.h"
      int main() {
        return (int)function();
      }
    EOS
    expected_output = <<~EOS
      main.c should add these lines:
      #include "direct.h"  // for function

      main.c should remove these lines:
      - #include "indirect.h"  // lines 1-1

      The full include-list for main.c:
      #include "direct.h"  // for function
      ---
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.c 2>&1")

    (testpath/"main.cc").write <<~EOS
      #include <iostream>
      int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    expected_output = <<~EOS
      (main.cc has correct #includes/fwd-decls)
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.cc 2>&1")
  end
end
