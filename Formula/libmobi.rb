class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.11/libmobi-0.11.tar.gz"
  sha256 "6a7cbfb2b8f00849f02af3d913a694a0d7c7e7acb6b801625373f32e57db8051"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8910ccf86e81bb038762ff0f07239a16bfbe36321c682042ef0e7b594cc30154"
    sha256 cellar: :any,                 arm64_big_sur:  "acb868d0c49f811fe952cb7a5d1844dfaefc8d1c845486c4fddb10c0304b2a7b"
    sha256 cellar: :any,                 monterey:       "fd2601afa5199daa00c077c7aa7e3fd2f47e2f54f6661678c3474d6cc5d7f681"
    sha256 cellar: :any,                 big_sur:        "481e9486192ed6cea54c75465612f23675434fb5efea26267cdb944120a75851"
    sha256 cellar: :any,                 catalina:       "ca52fa0e0ffad550d104ac35f6d45d24d4e02478f76ff15e1650d38de66d26b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c582c8d248ba77c93065c9e71658ea1a8e6b8e4f5e22d512e17d7a67f1d28d"
  end

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
