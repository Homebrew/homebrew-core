class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  license "NCSA"

  stable do
    url "https://include-what-you-use.org/downloads/include-what-you-use-0.20.src.tar.gz"
    sha256 "75fce1e6485f280f8f13f4c2d090b11d2fd2102b50857507c8413a919b7af899"
    depends_on "llvm"
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
    sha256 cellar: :any,                 arm64_ventura:  "8918358c35d6ed83fd69341673082bd01e4ab9acfd7cb1122419cfc5f67508f6"
    sha256 cellar: :any,                 arm64_monterey: "4cb45fa8a071aeadca70a16f73d47a932a4ce724610f82ece15085bc6c690b1d"
    sha256 cellar: :any,                 arm64_big_sur:  "51b47c1d0b805af1b7b662f5a84e0c1e03a451d3cd1e2a27eee6c65e59d3bace"
    sha256 cellar: :any,                 ventura:        "259f6b1fe808104d1b3f34864cb4cc9087ff5a22be0cfdc883d042fc2b289fbf"
    sha256 cellar: :any,                 monterey:       "09db32abec4f0ff8ae1be3c49a46a7211b172d41b241b1e1f9bef88b38e97395"
    sha256 cellar: :any,                 big_sur:        "c59a3a2e24917baa8c964ff26dba554806ada6f837bacdfb1184045889acf0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c640f19b35c91e79733fae1ef63235eb6caf16a3fb30f58ad8f198b04b1f1171"
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
    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
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
