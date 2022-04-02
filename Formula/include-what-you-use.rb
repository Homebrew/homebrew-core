class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.18.src.tar.gz"
  sha256 "9102fc8419294757df86a89ce6ec305f8d90a818d1f2598a139d15eb1894b8f3"
  license "NCSA"
  head "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https://include-what-you-use.org/downloads/"
    regex(/href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c849e210107d49902d6cefe58ca3af7afc4a1a197f1239da4d26639e6eef4a49"
    sha256 cellar: :any,                 arm64_big_sur:  "47ced9c1ae76704cb14d2ea2d3e1ab29c66d650387576d1f931b102ee44c96ed"
    sha256 cellar: :any,                 monterey:       "0a84098cd52678381ca12ee9986e59c6cda595a10877ecb974d4445251017fe6"
    sha256 cellar: :any,                 big_sur:        "657ab0dd0639344d923f288e3ab5130b1ad6094d516eea05526dc4fc966dc230"
    sha256 cellar: :any,                 catalina:       "e817cfbf7abeced52eb5596dc1b2a59da1c624b7adcb276677a9d7ed71762ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257d7f45e2b1c30d46254a6b7786b38eefb483853ab599995a296b230908d128"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm(@\d+(\.\d+)*)?$" }
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
