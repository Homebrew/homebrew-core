class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.13.1.tar.gz"
  sha256 "6a4976887594ec9f4e8521c95598dbbc478c59733056a5cf46354e93a1bc8400"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "58cd0113bf0363839bcc0cf6e08798873d0acf572de8efb895583744d8694a01" => :sierra
    sha256 "71a374a011ec7da1f451c27b0e03a89f4c66f729b390115c10e5dcc656cd5099" => :el_capitan
    sha256 "eef3b088de095b55e3975f076f67450ba6a4dbd7a31c9584f3bfd6e1196a6642" => :yosemite
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
