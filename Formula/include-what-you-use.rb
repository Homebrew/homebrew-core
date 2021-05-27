class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.16.src.tar.gz"
  sha256 "8d6fc9b255343bc1e5ec459e39512df1d51c60e03562985e0076036119ff5a1c"
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
    sha256 arm64_big_sur: "921f11702bc6b7f053aa9ce19e0c67231736dc70a57a300c6386f982086cbe00"
    sha256 big_sur:       "2b01505cfa7e2328ba69bb201900bd405092d0cfcd0fbbed935bc105872e79a4"
    sha256 catalina:      "27c7be4910d197d0670a2f20f980f691576894165726d972421f55c5dec1ae12"
    sha256 mojave:        "4add4a025d4634dd620f9f6eb61e59084f3d8841ee2ea44e9b37a9f39832269a"
  end

  depends_on "cmake" => :build
  depends_on "llvm" # include-what-you-use 0.16 is compatible with llvm 12.0

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    llvm = Formula["llvm"]

    # We do not want to symlink clang or libc++ headers into HOMEBREW_PREFIX,
    # so install to libexec to ensure that the resource path, which is always
    # computed relative to the location of the include-what-you-use executable
    # and is not configurable, is also located under libexec.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{llvm.opt_lib}
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
    (libexec/"lib").install_symlink llvm.opt_lib/"clang"
    (libexec/"include").install_symlink llvm.opt_include/"c++"
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
