class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  license "NCSA"
  revision 1

  stable do
    url "https://include-what-you-use.org/downloads/include-what-you-use-0.24.src.tar.gz"
    sha256 "a23421ceff601d3ea215e8fa9292bfa8ca39eb1ac2098dbbedfc6cfe65541c10"
    depends_on "llvm@20" # TODO: use `llvm` in 0.25
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
    sha256 arm64_tahoe:   "a687e26c677a72735d4d90756990d895f57394f1a177546a5f4caa3235d9aedd"
    sha256 arm64_sequoia: "a4ddb8fded4e60f585786a9812ea44463605664e4e08f9699a46fbdba6d792bd"
    sha256 arm64_sonoma:  "a84ad2297f240dfaf9c93b7faf3b0454fdaa3bf5894b6324942a518cd12aaf92"
    sha256 arm64_ventura: "024a17a51b89dd85b62e2ed1cb27750d4a1c7e332111eef74754c3aa61254c97"
    sha256 sonoma:        "af4b93c97732e208b154f0c8ad25704388db44b728415db0fc82d4b32c538bca"
    sha256 ventura:       "98a1fa193264a29dd811f4acac7172999a991fe80e1894f7afedfb7ca64f7246"
    sha256 arm64_linux:   "0ee5d2b838c652f4d129eaf73cdcac8a1c1b587153f6a8b76ebf6a7db4165e1f"
    sha256 x86_64_linux:  "b08052109946612bea46917bd7e110d436618f49f214a07e84bf8c8c55dbbc39"
  end

  head do
    url "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
    (testpath/"direct.h").write <<~C
      #include <stddef.h>
      size_t function() { return (size_t)0; }
    C
    (testpath/"indirect.h").write <<~C
      #include "direct.h"
    C
    (testpath/"main.c").write <<~C
      #include "indirect.h"
      int main() {
        return (int)function();
      }
    C
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

    mapping_file = "#{llvm.opt_include}/c++/v1/libcxx.imp"
    (testpath/"main.cc").write <<~CPP
      #include <iostream>
      int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    expected_output = <<~EOS
      (main.cc has correct #includes/fwd-decls)
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.cc -Xiwyu --mapping_file=#{mapping_file} 2>&1")
  end
end
