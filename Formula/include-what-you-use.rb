class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.14.src.tar.gz"
  sha256 "43184397db57660c32e3298a6b1fd5ab82e808a1f5ab0591d6745f8d256200ef"
  license "NCSA"

  bottle do
    sha256 "045a0b40290cc8da9122eef0a51c8badbd972ae1a90a3bf101f9e26f90fb6b25" => :catalina
    sha256 "4624e7bc1b0c8775db0ab2a48c6bdafcf51dea562e3e9f227940746db375c783" => :mojave
    sha256 "8ae01240a58564995908d2ffae8a87cf678be65511b36ad29da804ba93509aa9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm@9" # include-what-you-use 0.14 is compatible with llvm 9.0

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # patch to make the build work with llvm9
  patch do
    url "https://github.com/include-what-you-use/include-what-you-use/commit/576c30a31ec3f6592a0fd68b0d19cb0880203569.diff?full_index=1"
    sha256 "fe0ecc5a018d12a8865297747d293546f9fc35be22935ec74dc2a34234f90a73"
  end

  def install
    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{Formula["llvm@9"].opt_lib}
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
    mkdir_p libexec/"lib/clang/#{Formula["llvm@9"].version}"
    cp_r Formula["llvm@9"].opt_lib/"clang/#{Formula["llvm@9"].version}/include",
      libexec/"lib/clang/#{Formula["llvm@9"].version}"
    mkdir_p libexec/"include"
    cp_r Formula["llvm@9"].opt_include/"c++", libexec/"include"
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
