class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.9.1.tar.gz"
  sha256 "a6ca9f0648973d1463f46b495ce546ddcbe7cce2f04b32e802a15539e46c57ad"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "b88c42381d2f77fd83aed8018b4584709f7cce3f4cb2af7cd171eb1193020040" => :el_capitan
    sha256 "0a0fd0629f0948344455ce2bbe3318f9a9c72b0335a367a68bad21b1e24e1c40" => :yosemite
    sha256 "809d792e814d311c6066ca13d0b38fed4c150c14bac716033979f33c5cd8c33f" => :mavericks
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
