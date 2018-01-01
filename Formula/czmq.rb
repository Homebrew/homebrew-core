class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.1.0/czmq-4.1.0.tar.gz"
  sha256 "3befa35b4886b5298e8329b4f0aa5bb9bde0e7439bd3c5c53295cb988371fc11"

  bottle do
    cellar :any
    sha256 "6ae4500d7fc4941770348a07cfd5144b102dba6ff714411e406c9accd45490e4" => :high_sierra
    sha256 "5e7c9ba51cf01d6bd653b727a50ffef388e17aa7a6732f769cbc33e64a8bde69" => :sierra
    sha256 "52a626dc63cbb469a726230389ad5388fe218399380a7868a46429d6392bb38c" => :el_capitan
    sha256 "e68078e86128bb2aba85c7bbc765f962fc5e506b1886712a255064af2fa4a844" => :yosemite
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-drafts", "Build and install draft classes and methods"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "zeromq"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-drafts" if build.with? "drafts"

    system "./autogen.sh" if build.head?
    system "./configure", *args
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
