class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.38.1.tar.gz"
  sha256 "2177fca2426ac60c20f654323656e843dac4f568d46674544b78f416697bd32c"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  bottle do
    cellar :any
    sha256 "012d3650f4b0e47216a8ccb77233f3acb8cd0be938ae2fd3759095b641df583e" => :catalina
    sha256 "fc62cdd8db495791a5d2aa9209b5825dca9e84b8a35fe57d8ad5a912dd29bb00" => :mojave
    sha256 "7e99c956433dce12612f6e1294281bcf3bd6fc24788e81465f7e2e1346439120" => :high_sierra
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
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
