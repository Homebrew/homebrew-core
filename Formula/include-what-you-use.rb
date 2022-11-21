class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.19.src.tar.gz"
  sha256 "2b10157b60ea08adc08e3896b4921c73fcadd5ec4eb652b29a34129d501e5ee0"
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
    sha256 cellar: :any,                 arm64_ventura:  "9cd980ebf2328c24e34e5b8f383f845e8c5de2d29d5904f61d5c1ec1e5f7758f"
    sha256 cellar: :any,                 arm64_monterey: "74bffb0dc7dce47d0dc66a334ae2f97d706832527d8238d87b1b55ac7f774426"
    sha256 cellar: :any,                 arm64_big_sur:  "395a9b31cb4e9024488e33dff157836d6c833cdda34b57f1882aa18140027870"
    sha256 cellar: :any,                 ventura:        "5055c407f01109a7c2791335c3ae8d49cf5e43eb30d8d39a99c83a582da088e7"
    sha256 cellar: :any,                 monterey:       "a3c265161618434e2f7309e3a40d4450a52be8a2ad10ad6866b3fbc489a62ede"
    sha256 cellar: :any,                 big_sur:        "d468ab80a9508cd22dc08d5fba619209aef43d3b527db3522fc2a13dfaabec27"
    sha256 cellar: :any,                 catalina:       "7c460a64c73fc4b03690b68c1928b2a0bd8afb1aa4a62a11ba2f28898a47833f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3518a3e1f2fa504af9571c3988f626df0b3b0842f2c811d9b3c89d85e1c011eb"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
