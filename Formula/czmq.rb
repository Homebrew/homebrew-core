class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/archive/v3.0.2.tar.gz"
  sha256 "e56f8498daf70310b31c42669b2f9b753c5e747eafaff6d4fdac26d72a474b27"
  revision 3

  head "https://github.com/zeromq/czmq.git"

  bottle do
    cellar :any
    sha256 "9bbf6566cd74644ae22f5dd9338c1123bf3ecdf7a920dcaabf166aeb3902e3f7" => :el_capitan
    sha256 "4a569da4e60f3b8252b4ef9a998e50153ac119108135ce832f2494b0edf7e87a" => :yosemite
    sha256 "ae42e5b89ed47c00a3a45d9c3a4759a2f0a772c787f62b34cb024f489790efff" => :mavericks
  end

  conflicts_with "mono", :because => "both install `makecert` binaries"

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium" => :recommended

  if build.without? "libsodium"
    depends_on "zeromq" => "without-libsodium"
  else
    depends_on "zeromq"
  end

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-libsodium" if build.with? "libsodium"

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
