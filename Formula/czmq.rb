class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  revision 1

  stable do
    url "https://github.com/zeromq/czmq/releases/download/v4.1.0/czmq-4.1.0.tar.gz"
    sha256 "3befa35b4886b5298e8329b4f0aa5bb9bde0e7439bd3c5c53295cb988371fc11"

    # ZeroMQ 4.2.4 compatibility
    # 7 Mar 2018 "Problem: atexit called after zmq static object destruction"
    patch do
      url "https://github.com/zeromq/czmq/commit/7debf8ff8.patch?full_index=1"
      sha256 "b797072908bcdfb2e11bbabe0351c9392b4946ae99d439d34bd922a77d7896c9"
    end
  end

  bottle do
    cellar :any
    sha256 "1530e0574a63f6d6a4a5526ed15bb7fc18fac8950cfed2e1b6c46b4990b62d78" => :high_sierra
    sha256 "47513eabd5e660fc4dcaf7c37e06d5e0ce0ac78075a2c02e76b62c4253a39a5b" => :sierra
    sha256 "01dc807c195351b97b5c007dda0b0c3fc27f549eec97ce08de9a9aba8fb83763" => :el_capitan
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
