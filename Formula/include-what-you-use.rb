class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  license "NCSA"
  revision 2

  stable do
    url "https://include-what-you-use.org/downloads/include-what-you-use-0.16.src.tar.gz"
    sha256 "8d6fc9b255343bc1e5ec459e39512df1d51c60e03562985e0076036119ff5a1c"
    depends_on "llvm@12" # include-what-you-use 0.16 is compatible with llvm 12.0
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
    sha256 cellar: :any,                 arm64_monterey: "f15c404e4cfca39e9db2728bc10891e1709497afe6d8d88bca6194f08b0f2f63"
    sha256 cellar: :any,                 arm64_big_sur:  "8b4ba730248b474d711ded0a5c713fcf303f5fed1cc476f201cb66dd4aeebd3f"
    sha256 cellar: :any,                 monterey:       "0dcafa706570811b0a93c61f2ef8f40f1561c6a818580b89a1abb13c062d77c9"
    sha256 cellar: :any,                 big_sur:        "4abf6a45d2f3215a71340ebf920af51b6737dd49b536d1c030bab31860616d23"
    sha256 cellar: :any,                 catalina:       "d7cf6d888dd73d6bf28ea4b455e749d5532ee2647b1168a575efa8107f6831d7"
    sha256 cellar: :any,                 mojave:         "c2024ce23c44b1a084f144cf378fb56d9c5af4b52eca7502fc7c7961ffa82ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67fb75245fd62d1724bcaebbc22012f19a0721c8d1d661c74e2cf87923732e50"
  end

  head do
    url "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{llvm.opt_lib}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

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
      shell_output("#{bin}/include-what-you-use main.c 2>&1", 4)

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
      shell_output("#{bin}/include-what-you-use main.cc 2>&1", 2)
  end
end
