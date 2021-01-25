class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.2.0/czmq-4.2.0.tar.gz"
  sha256 "cfab29c2b3cc8a845749758a51e1dd5f5160c1ef57e2a41ea96e4c2dcc8feceb"
  license "MPL-2.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b457eb58a8684ba745af98d60a4207aef695bb33531206f2f7c0287523cd9a2a" => :big_sur
    sha256 "f8b5ef84a357ca7fbd03d2a0a5fc5f5714cf28dc5321479f0dc715c348df75c9" => :arm64_big_sur
    sha256 "c20bd8fd5e9c223824b1b50e829fb6c1ff1096951b20379f5f070b300d7e67d8" => :catalina
    sha256 "e64d0f79d6a05b5648695e3d06331bb34e8b85ae5920f429f3b44b7eee23cf5e" => :mojave
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
  depends_on :macos # Due to Python 2
  depends_on "zeromq"

  # These two patches together fix https://github.com/zeromq/czmq/issues/2125
  patch do
    url "https://github.com/zeromq/czmq/commit/ace06a41da51b1196eef411669343cdf7e8665e2.patch?full_index=1"
    sha256 "d5e8ed6d96ba63ebb8128032cc4ffef2cbd49b9af9692ad60b89bb3bcf6b2b4c"
  end
  patch do
    url "https://github.com/zeromq/czmq/commit/0c7cac3be12707225d03888a6047e5133d926751.patch?full_index=1"
    sha256 "62e6b211018a837ad1b8aed82c14740b87c13509e4a444a9cfeb5a50188eaf5e"
  end

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
