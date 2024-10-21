class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.49.2.tar.gz"
  sha256 "388ffcf3370d4cf7c4b3a3205504eea06c4be5f9e80d2ab32d19f8235accc1cf"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b28a00add187590626c395c52a9295857fc1320e9ff0b8dd9fe726f4614ebcf"
    sha256 cellar: :any,                 arm64_sonoma:  "bf7e4fc58b402b235dabb022fcba6e7960c8e1afb28e482a35771345de91d117"
    sha256 cellar: :any,                 arm64_ventura: "f7f9df3d16699a31cd90bd8e5a8172d590c3f18bef7c03f6cd0bdf32fa4b968e"
    sha256 cellar: :any,                 sonoma:        "1c30f58448ce9c0d30cef601a475a1986d1cf072188b110adf783c7002a9b559"
    sha256 cellar: :any,                 ventura:       "219fe43b746aaaa223c27cedf8634da8e0977a4e03bf970c254dc050e300da29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d13b73eee595b1bf4157d8c047bcdbc46f61b8a3aa2d7225d80a9183849396"
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
