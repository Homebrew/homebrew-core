class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.44.2.tar.gz"
  sha256 "e6e2ba8b4c349a4182a33370bb9be5e23c51b32efb9b9e209d0e8556b73a48da"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2653486daddca69315ee9b5bd12c7ba262ecc5a159ddd1d0277a3e5fb14708ac"
    sha256 cellar: :any,                 arm64_monterey: "1134b22185efdff666f68f334152bb7b37863fc7310e1403089daff68ffdc124"
    sha256 cellar: :any,                 arm64_big_sur:  "3955c77e5544e84fa8361a1453b1c0232ff15e275d46ce54ad6eb9b348370ad8"
    sha256 cellar: :any,                 ventura:        "d3cc5bca7fe7512842102366b45b1948099eb8c24ab53093821295586b2de76d"
    sha256 cellar: :any,                 monterey:       "ccef3d8ae2170307a515e657236b97ee605ce614b8fee0f42da19ae3d8efeee1"
    sha256 cellar: :any,                 big_sur:        "5edaadbf90ddeedd193ac1c4edca1e76c5ac08ca42be0c9a44d2fd0a9b6b65d0"
    sha256 cellar: :any,                 catalina:       "02f2d420b10d5c33971792e41b0cf77f899289d5bec2aece5db7946a8e741f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b17d90c050a0e09a3e84a58bfd00314fb0b90e87a6235cc3327b004b014f8cf"
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
