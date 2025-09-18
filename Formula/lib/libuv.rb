class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "27e55cf7083913bfb6826ca78cde9de7647cded648d35f24163f2d31bb9f51cd"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4baeae937cc36f3daf93336337b69357f9b666ec89ecb4937999f46cde964627"
    sha256 cellar: :any,                 arm64_sequoia: "47f6323a3b3ac0d2026ac75948e54b940bce1cc2ed3b809818bada0fca0b402b"
    sha256 cellar: :any,                 arm64_sonoma:  "594446ed876368a6ef6bf158fb6e1fdadd3973b1813846994423f417a7e5b965"
    sha256 cellar: :any,                 arm64_ventura: "db92705f40c7175fc957ad40ca096ab9577d20ea0d6782e7051bb1e0a1df21b1"
    sha256 cellar: :any,                 sonoma:        "89296bb1520f6d2f60061a6dee3c8f0ad4a86e69e37c4c452223267a411b0c35"
    sha256 cellar: :any,                 ventura:       "c760f64fff00acf565b63456ea48c6f8348eb58d81aa8632acb6bfc209455bd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcfffc19eff957b8cdc9f007580435ce70d6315c19f737c55c9979f43e14955f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674de0e23792c9d2135a04cd3df09655e68768a30e393f16fd527de1c9df7579"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    system "make", "-C", "docs", "man"
    man1.install "docs/build/man/libuv.1"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
