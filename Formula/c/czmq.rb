class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  license "MPL-2.0"

  stable do
    url "https://github.com/zeromq/czmq/releases/download/v4.2.1/czmq-4.2.1.tar.gz"
    sha256 "5d720a204c2a58645d6f7643af15d563a712dad98c9d32c1ed913377daa6ac39"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end

    # Fix `Abort trap: 6`
    # https://github.com/zeromq/czmq/issues/2155
    # remove in next release
    patch do
      url "https://github.com/zeromq/czmq/commit/7f744f730941dc8ca68750cd977a38a655d1a646.patch?full_index=1"
      sha256 "efd3749181bedaab37348ca0fe2efa3db77c4b9d46a49f410476d8473cb20c01"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "256774bf2e64754f05e01944246e707c92472656a9d9b7680962a0ecf6372ddf"
    sha256 cellar: :any,                 arm64_sequoia:  "563fccc28279b87f02a5545f8e041090ead4e42f04f5df7e50b421abbb88f1eb"
    sha256 cellar: :any,                 arm64_sonoma:   "cce35246b601a70fecc64be08943a2c893d9ad2dd2567a3ec3c17a270a8a80b4"
    sha256 cellar: :any,                 arm64_ventura:  "e51e2cc5ccca8943ab12a1587eb9b6aa533603ea2575db6928827bdaa0d807d1"
    sha256 cellar: :any,                 arm64_monterey: "47bd6d29801b9d1a33d2d1e0655192e500e8c2a7698083d0838b178c068d5cd4"
    sha256 cellar: :any,                 arm64_big_sur:  "f1fd8af878b29414140b01fd729603d328a6f3ed3a520c967db05a231361c9bf"
    sha256 cellar: :any,                 sonoma:         "dc9cc7878cc5660a6b8a16c59bc158519aa391e26d2e9ddec744895bb52c0b9b"
    sha256 cellar: :any,                 ventura:        "67d8bb3b5214620f2e55a65b779e4d92affde8d6468ac25eccc5b4d1ac504ee8"
    sha256 cellar: :any,                 monterey:       "300244e12b2cc498876e3b6a346f8ad24ccf1a256d8dc84c4e00b594c71c4bce"
    sha256 cellar: :any,                 big_sur:        "d5abd045c165de80872c22ecf503132110c26e35d05b0b50c78dec97fd31e628"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55340fbd1cbc1236fd899f432fcbf4501f9ec3761c7e3d141a0efd3e807fe75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "376bc4229fd95f09cf0fed87437a5b7ede0698f2846abd1199cde96aae7a86fe"
  end

  head do
    url "https://github.com/zeromq/czmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "lz4"
  depends_on "zeromq"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "ZSYS_INTERFACE=lo0", "check-verbose"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <czmq.h>

      int main(void)
      {
        zsock_t *push = zsock_new_push("inproc://hello-world");
        zsock_t *pull = zsock_new_pull("inproc://hello-world");

        zstr_send(push, "Hello, World!");
        char *string = zstr_recv(pull);
        puts(string);
        zstr_free(&string);

        zsock_destroy(&pull);
        zsock_destroy(&push);

        return 0;
      }
    C

    flags = ENV.cflags.to_s.split + %W[
      -I#{include}
      -L#{lib}
      -lczmq
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    assert_equal "Hello, World!\n", shell_output("./test")
  end
end
