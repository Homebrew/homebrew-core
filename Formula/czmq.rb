class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.0.1/czmq-4.0.1.tar.gz"
  sha256 "0fc7294d983df7c2d6dc9b28ad7cd970377d25b33103aa82932bdb7fa6207215"

  bottle do
    cellar :any
    sha256 "3f61414bc6aabc62f0ae3423b167e7101955843dd81c5b92c6edb4aff9c6ece8" => :sierra
    sha256 "9bbf6566cd74644ae22f5dd9338c1123bf3ecdf7a920dcaabf166aeb3902e3f7" => :el_capitan
    sha256 "4a569da4e60f3b8252b4ef9a998e50153ac119108135ce832f2494b0edf7e87a" => :yosemite
    sha256 "ae42e5b89ed47c00a3a45d9c3a4759a2f0a772c787f62b34cb024f489790efff" => :mavericks
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-drafts", "Build and install draft classes and methods"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "zeromq"

  conflicts_with "mono", :because => "both install `makecert` binaries"

  def install
    ENV.universal_binary if build.universal?
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
