class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "27e55cf7083913bfb6826ca78cde9de7647cded648d35f24163f2d31bb9f51cd"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "916f444748e98c1e58083df123f6ff9d90d0b0af202f4da0862a5c456804d2f2"
    sha256 cellar: :any,                 arm64_sonoma:  "571859f2cb6de90cfea1d1c6d059e3234ddf8b182e0d494bc9c902ebea191710"
    sha256 cellar: :any,                 arm64_ventura: "5b883ed2838104b6a8026068ac4b9d6e04dc6fb8f899f522754b426afee4e801"
    sha256 cellar: :any,                 sonoma:        "fb199706c025af4c6160825de25f9220c8d571499c5dba71c4b93a3874ea7a03"
    sha256 cellar: :any,                 ventura:       "ced40d8e5768027c89dc194e21e1e52c15a38a932e04d8026a2ebc5ec4944422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1dcb33e480bb395e58b2c0e775f36041af343e7be3cf5d53d666fb55f753ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1d243f009617c2ff2d97c5cd08a93512f93accf7d7c1987a649db2b91ac03e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      man1.install "build/man/libuv.1"
    end

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
