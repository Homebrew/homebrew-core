class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.15.0.tar.gz"
  sha256 "17afc94ec307be28fe8d4316679171219770df4f993905a79643c7583e106489"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "cec3f2640153984e27c2b35572174824be402dd7c84b690c774ff421c36a2f29" => :high_sierra
    sha256 "0c0d0c8cd3bb1e315349dd2fb29ba3a44d4197e211056e046c9c54e0be73d8f2" => :sierra
    sha256 "9870b72d6a28333b9b25535fe7b9ef6b3ff6c1c97e6c7122e6d045933099f83c" => :el_capitan
    sha256 "d49f409089498c450c7647c7d238cfdb222d5b094e71e48c22f3e4f98f07dcbb" => :yosemite
  end

  option "with-test", "Execute compile time checks (Requires Internet connection)"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
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
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
