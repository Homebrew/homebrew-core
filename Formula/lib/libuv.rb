class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org/"
  url "https://dist.libuv.org/dist/v1.52.1/libuv-v1.52.1.tar.gz"
  sha256 "66d511b9e6e334c0e62279eb234fbfb2b3110b1479c09b95b44c7afca8cff9e7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e8478545dc49bd505a4fac61617cd15d8fec4475d2add5ea1cc92f7281818bf"
    sha256 cellar: :any,                 arm64_sequoia: "495b7322c4b9d0a2e5ceb96de24f5cc10d781e99179f94ca5e31d350547a235d"
    sha256 cellar: :any,                 arm64_sonoma:  "6300ab64e5d20aa145fe987c40f65f994a54f571cf113d96100c07feb98e0c10"
    sha256 cellar: :any,                 sonoma:        "4630cfebfbc75d75a085568e7e6183cc805271871aa8d70f5fa515b05141f641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "601a1e2db4efec5d8464aba357970310183925c80fe32c7b449fbfc8b8d71b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4d9ac18871f6a4f4250be25da29e904755fb3067c8fb08d48fdc71311c623b"
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
