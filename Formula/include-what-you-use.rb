class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.12.src.tar.gz"
  sha256 "a5892fb0abccb820c394e4e245c00ef30fc94e4ae58a048b23f94047c0816025"

  bottle do
    sha256 "a27076eb4615c5d58a838a2afcb037565a863bc24df30074fdb65785819bdf0f" => :catalina
    sha256 "e5ce12e2d2b7056d8ece7ceb99d4763af538f1c4890135f47979e5cf38306c5d" => :mojave
    sha256 "4bf150841df194cf4b56ca9e014b6f2f4bf6ff934d884f33847621094ee5a995" => :high_sierra
    sha256 "eb35442872740e747b0e526097cac632fec3fadcaa94ba1ecfd5396d10671acc" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" # include-what-you-use 0.12 is compatible with llvm 8.0

  def install
    # We do not want to symlink clang headers into HOMEBREW_PREFIX, so install
    # to libexec to ensure that the resource path, which is always computed
    # relative to the location of the include-what-you-use executable and is
    # not configurable, is also located under libexec.
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{Formula["llvm"].opt_lib}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # include-what-you-use needs a copy of the clang headers to be located
    # in a specific folder under its resource path. These may need to be
    # updated when new major versions of llvm are released, i.e., by
    # incrementing the version of include-what-you-use or the revision of this
    # formula. This would be indicated by include-what-you-use failing to
    # locate stddef.h when running the test block below.
    # https://clang.llvm.org/docs/LibTooling.html#libtooling-builtin-includes
    mkdir_p libexec/"lib/clang/#{Formula["llvm"].version}/include"
    cp_r Dir["#{Formula["llvm"].opt_lib}/clang/#{Formula["llvm"].version}/include/*"],
      libexec/"lib/clang/#{Formula["llvm"].version}/include"
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
  end
end
