class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.2.0/czmq-4.2.0.tar.gz"
  sha256 "cfab29c2b3cc8a845749758a51e1dd5f5160c1ef57e2a41ea96e4c2dcc8feceb"

  bottle do
    cellar :any
    sha256 "c461e7f219ce378867918141470c871871c9e0aec437ceb52cc858f61811aece" => :catalina
    sha256 "19b9f2b1d8d73f7314d0534f22bacd8bc02b39b2a985a07fc8e40365583fc45e" => :mojave
    sha256 "a1afab02e1ff88b48e2bd92900a701745e18fb05ca700d5c2635fa4c986010f8" => :high_sierra
    sha256 "d64960ca3558f8a571a51095b9c0e41b1eb8c535e2efc0882ea20c44a41b5563" => :sierra
  end

  head do
    url "https://github.com/zeromq/czmq.git"

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
