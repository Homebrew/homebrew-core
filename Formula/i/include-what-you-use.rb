class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.25.src.tar.gz"
  sha256 "be81f9d5498881462465060ddc28b587c01254255c706d397d1a494d69eb5efd"
  license "NCSA"
  revision 2
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
    sha256 cellar: :any,                 arm64_tahoe:   "cb16a8422501ee26489ab0dc70d2137f66fab074435382c390efa33271290a24"
    sha256 cellar: :any,                 arm64_sequoia: "680eeeb2004d29b000e4b24ff69136cb988f903b8a9ede72be642427a9128965"
    sha256 cellar: :any,                 arm64_sonoma:  "e90a4915c7ab8fe751a8dc6038539657d1ce3b1d9ddd76c19cb92af846946fe1"
    sha256 cellar: :any,                 sonoma:        "d0f141120aaede9cf0d38d68b2f09907b02aadcd4b36abcf44fb14e82c06e15c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1f672fc5f6b859f9b7935ef7ec93826ec067eca641b6bc45c4aaea888bf424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de767ccb3a6ffb9f5fa5ac5e71202381a2aeb4b22de7d1df06c96a262f431e5c"
  end

  depends_on "cmake" => :build
  depends_on "llvm@21"
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
