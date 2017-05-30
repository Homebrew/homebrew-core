class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.12.0.tar.gz"
  sha256 "41ce914a88da21d3b07a76023beca57576ca5b376c6ac440c80bc581cbca1250"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "aa4195b32133c3bb4cbbb564f4742112ddffb7a2e894f4db19da740d33faff36" => :sierra
    sha256 "4cbae976a0154925d89e72fed2773c4a68b36500890de385d8b2029cfe8c2a31" => :el_capitan
    sha256 "767141dbd4cdbbe390ec292f0119135af5c9c6b5dc4804544f9dc3b9c2f2c65a" => :yosemite
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
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end
