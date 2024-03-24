class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.22.src.tar.gz"
  sha256 "859074b461ea4b8325a73418c207ca33b5e6566b08e6b587eb9164416569a6dd"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d73713688df68b04e19cbb9c0e4317f7524d74258d35b516aeb8e016870bc491"
    sha256 cellar: :any,                 arm64_ventura:  "c18fc64dead650d5e5b34606188f6fcd98ed57661cb8c774b2ae3468ae0e0dac"
    sha256 cellar: :any,                 arm64_monterey: "66ead0c020efe55e4330871f5b0ee60a375df1d4edfa7f0ad8ecc04ae0ac584e"
    sha256 cellar: :any,                 sonoma:         "272aaff9519d7010989ba3e41d5dd0aabe73fe83d1466f30c545fd2fe1a796c9"
    sha256 cellar: :any,                 ventura:        "ccff25bc7fbd08fab7f333b2ad385515abfc35b70019e62f3a3b408738da38bb"
    sha256 cellar: :any,                 monterey:       "3927a880a129bb8767a416f964b811fc051fc0f76c373e40e1e62742de721827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "097776120d33c8f1eb54bc676e874dd1736528422561c40bdcb7947b35868a7e"
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
