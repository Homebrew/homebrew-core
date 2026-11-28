class Debugbreak < Formula
  desc "Break into the debugger programmatically"
  homepage "https://github.com/scottt/debugbreak"
  url "https://github.com/scottt/debugbreak/archive/refs/tags/v1.0.tar.gz"
  sha256 "62089680cc1cd0857519e2865b274ed7534bfa7ddfce19d72ffee41d4921ae2f"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    manifest_sha256 "e8d2e8e61d33dc2c3d4cf0aa8d76f36bdb08e58e68810af93ddb78e11283452c"
    sha256 cellar: :any_skip_relocation, all: "c3d74ba626694bb1db1d81d3efac9b1a9ca9c71521212bb937bfd897d677272f"
  end

  def install
    include.install "debugbreak.h"
    pkgshare.install "debugbreak-gdb.py"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <debugbreak.h>
      int main() {
        debug_break(); /* will break into debugger */
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-o", "test"
    pid = Process.spawn("./test")
    assert_equal Signal.list.fetch("TRAP"), Process::Status.wait(pid).termsig
  end
end
