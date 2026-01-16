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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "febb29971c3e8ec198cc46aab490b9d5a1b1f9897618ab0c08d571fc7e405e24"
    sha256 cellar: :any,                 arm64_sequoia: "213bdf2e2a8094c3f9e80f9453529e459075b00667aa3869488ca330633c8d7e"
    sha256 cellar: :any,                 arm64_sonoma:  "ce1afe4cf2eda64076bcecc7ac53578564fded555d6786ab46b5b26fd8022679"
    sha256 cellar: :any,                 sonoma:        "5525b7f43377fd15a36821b00c8fcda1cffa466315fc189881cd843e6a14ec54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c63e00abc6b27ee41877b9dab66a79f961be696bd0899649dc48c4e7ba02a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33758f6714ab8c29596918913cd70a1f162406e4ea2c161ba5a55f932bf4d90c"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
