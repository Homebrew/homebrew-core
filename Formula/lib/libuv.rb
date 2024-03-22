class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "8c253adb0f800926a6cbd1c6576abae0bc8eb86a4f891049b72f9e5b7dc58f33"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "803e5cefd2523e4f7fb2d70497df5df4b6bfbf3f285cfde9e9ff05f815bfb879"
    sha256 cellar: :any,                 arm64_ventura:  "5106b72009a33f1d670f25cf5d32b6262b68e8e56f6c81ed44fe52dc51434b08"
    sha256 cellar: :any,                 arm64_monterey: "d00a735e0a6d7d83a3e9a8194d6e98aac12b1d65a121c1b4355539fce0957593"
    sha256 cellar: :any,                 sonoma:         "06b2dfb049b8962aab284b4e79f6c930a511a6d91e70055e3ee2ac8c53a36109"
    sha256 cellar: :any,                 ventura:        "34884eec86c4979a89a979c513390a61b66c43cefc494f8379d7526b73032250"
    sha256 cellar: :any,                 monterey:       "a4a9a1c0a453231b4e808ec26312c2f8da069ba085d3b748369c09298d35102d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a002656a1f5136d4e6c5bfb22051fd5156860ad7d3e01b70db240ad76a87a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      man1.install "build/man/libuv.1"
    end

    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
