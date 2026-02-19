class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org/"
  url "https://dist.libuv.org/dist/v1.52.0/libuv-v1.52.0.tar.gz"
  sha256 "19fd091a582c39c7ea26dcbb40a7d2e7cf095b070a757b3c32c05de6cfed6638"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a96aec35787e6f9e8e3b999a04687a5331655d32d5c93ac47f7f4fa8c907d0c"
    sha256 cellar: :any,                 arm64_sequoia: "2ffa6012899f49b54c0e561deab4781cedc2f933c526bccb58a4b64e75a5169f"
    sha256 cellar: :any,                 arm64_sonoma:  "10219f371a41c37c4e252804759ecca9571986d30a46896b265f555f0405d4ee"
    sha256 cellar: :any,                 sonoma:        "48d8a4231c7b1aff74abc49b5aceb41cdc337b1773d7235fe763ba21eeb013e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96dc73df2ad0952ae92074ab66762308e1d6b29a8ba081b59f1a95c508b32985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceac8ca799cb1970dc17812ddb75a60f973723043221a504bc39fdc31e0aa44c"
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
