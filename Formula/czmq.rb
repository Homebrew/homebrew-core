class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  license "MPL-2.0"

  stable do
    url "https://github.com/zeromq/czmq/releases/download/v4.2.1/czmq-4.2.1.tar.gz"
    sha256 "5d720a204c2a58645d6f7643af15d563a712dad98c9d32c1ed913377daa6ac39"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e98cdc427523e0b6557dee75c9c7e02243e6deca7f154511de816a363380ae3"
    sha256 cellar: :any,                 arm64_big_sur:  "f038de51f9c505a739ca6d35804e800908e3180684516cd5df36e261207eb1e9"
    sha256 cellar: :any,                 monterey:       "659fd630f7a622c2e0677c74c43d0dffb0d6e000c3fd623f154f14534c71dd85"
    sha256 cellar: :any,                 big_sur:        "3adaa226cebf483c1f84a58dbc57ba6b75c51213216506d11b7dba6fde9f5ebb"
    sha256 cellar: :any,                 catalina:       "b7641290a58b85221b10754a16819de04db2258f852e0debc2e5a3b6581e6f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6567f78da8a3aec0856b30c7892a69933062b96b16a26170915ebfa86ce60bc5"
  end

  head do
    url "https://github.com/zeromq/czmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "zeromq"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "ZSYS_INTERFACE=lo0", "check-verbose"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    flags = ENV.cflags.to_s.split + %W[
      -I#{include}
      -L#{lib}
      -lczmq
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    assert_equal "Hello, World!\n", shell_output("./test")
  end
end
