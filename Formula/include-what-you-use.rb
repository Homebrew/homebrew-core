class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.15.src.tar.gz"
  sha256 "2bd6f2ae0d76e4a9412f468a5fa1af93d5f20bb66b9e7bf73479c31d789ac2e2"
  license "NCSA"

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https://include-what-you-use.org/downloads/"
    regex(/href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 "0bbf806279315bb9e367def80c0c537cd2a80ee3983ae87a9103cc3ae3640067" => :big_sur
    sha256 "564fe6fef3d7aff9903bb03c67e1124209533fba97463f7b4ed86f180ec46169" => :arm64_big_sur
    sha256 "63958bac561cef7a7370893c6716ca123ff585971bd3dd129158467a30fc2066" => :catalina
    sha256 "0794bc316e86146e2afecd05c22e18492cf703cf772f60ecdffee80991fa773f" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "llvm" # include-what-you-use 0.15 is compatible with llvm 11.0

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{Formula["llvm"].opt_lib}
      -DCMAKE_CXX_FLAGS=-std=gnu++14
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
    mkdir_p libexec/"lib/clang/#{Formula["llvm"].version}"
    cp_r Formula["llvm"].opt_lib/"clang/#{Formula["llvm"].version}/include",
      libexec/"lib/clang/#{Formula["llvm"].version}"
    mkdir_p libexec/"include"
    cp_r Formula["llvm"].opt_include/"c++", libexec/"include"
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
