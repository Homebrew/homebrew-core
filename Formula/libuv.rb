class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.10.0.tar.gz"
  sha256 "50f4ed57d65af4ab634e2cbdd90c49213020e15b4d77d3631feb633cbba9239f"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "a37079710595e7785a56183628fedb7541708938ab100387d8a3403f03d959ef" => :sierra
    sha256 "4a055f802d84f5311a29dcbbe0e4b4af06d67bf631169ec9b6e1a220af8678c4" => :el_capitan
    sha256 "2a5e0866c08f0fe234b67dcc8ac2f4bc65f0e434711e1266561d3be5778f9813" => :yosemite
  end

  option "without-docs", "Don't build and install documentation"
  option "with-test", "Execute compile time checks (Requires Internet connection)"
  option :universal

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    ENV.universal_binary if build.universal?

    if build.with? "docs"
      # This isn't yet handled by the make install process sadly.
      cd "docs" do
        system "make", "man"
        system "make", "singlehtml"
        man1.install "build/man/libuv.1"
        doc.install Dir["build/singlehtml/*"]
      end
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
