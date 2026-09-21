class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.26.src.tar.gz"
  sha256 "5247c0c9a59df9d14e8aa7408ffec4134c6a4aef12f590929111fbfeac930a08"
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
    sha256 cellar: :any, arm64_golden_gate: "c39c475e5e351ee17a97c1a221557fd3254c69cae84ad8b14d8b15a2a6441c04"
    sha256 cellar: :any, arm64_tahoe:       "3a0f1c08f818d98e8ce861ac7e81f3fc1b961e4306fdbd16c01eca692251ceb3"
    sha256 cellar: :any, arm64_sequoia:     "be4e111aa8c0a6a8a23204459dd102e525efaa4a6042a39e21b01cfa6ddf39c9"
    sha256 cellar: :any, arm64_sonoma:      "df2e90279bb2af185fdb734cf1dfa9d11e37315be75fd4f4cbee24f388758192"
    sha256 cellar: :any, sonoma:            "065ee1cb122dca1383d8523118c2b5fa0bd37d8f8ec372cbefa7e68351729b27"
    sha256 cellar: :any, arm64_linux:       "96b8344967aa0f947e016208ebbc886bc770c8d33de38b7026465c7bd05a751f"
    sha256 cellar: :any, x86_64_linux:      "03fb836be4a0e4e78830bb6d5f36012c5848a0312400091198935cbf6dd13ba2"
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
