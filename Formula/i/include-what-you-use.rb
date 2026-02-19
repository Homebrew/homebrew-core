class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.25.src.tar.gz"
  sha256 "be81f9d5498881462465060ddc28b587c01254255c706d397d1a494d69eb5efd"
  license "NCSA"
  revision 1
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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "7ea11c2a487d72b1c45d775c5a2d081a41fe1ad188a29dabc6fee981229e7e98"
    sha256 cellar: :any,                 arm64_sequoia: "72c066ce52b0bd94d3322804863ab5e803efe9063765a353bd53bb9b899db147"
    sha256 cellar: :any,                 arm64_sonoma:  "cdebade9904511920722ad2e8a0f270e6339b756860b6d03019fcc21e0c8e1e0"
    sha256 cellar: :any,                 sonoma:        "7d41e9fa66707ac5b16ba85801f5706bf72ec558896e2976d176a55a3b926561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032bf7068dce1c154e922b8a9d3234347684d601c9f9f21d242278dfc48ef7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf36f19b9dead1e1c607452d20f38cebd00259794f097e3b73f492de085d0c00"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
  end

  def install
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.sub! llvm.prefix.realpath, llvm.opt_prefix

    args = %W[
      -DIWYU_RESOURCE_RELATIVE_TO=iwyu
      -DIWYU_RESOURCE_DIR=#{Pathname(resource_dir).relative_path_from(bin)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
