class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"

  stable do
    url "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
    sha256 "71c2c49f0adadacfdbe6332a372c38cf9c8b7895bb73dabeaa53cdcc1d4e1fa3"

    # https://github.com/Homebrew/homebrew-core/issues/2869
    # https://github.com/libevent/libevent/issues/376
    patch do
      url "https://github.com/libevent/libevent/commit/df6f99e5b51a3.patch"
      sha256 "26e831f7b000c7a0d79fed68ddc1d9bd1f1c3fab8a3c150fcec04a3e282b1acb"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "de2aeabfb41fb7e601fb33948b81da4cd56b88bd5d1bfe325370924e75a81fae" => :sierra
    sha256 "1f18bad6b4b19c55ed11b63256241558923eea26814a7d551cf7384ffe0dd098" => :el_capitan
    sha256 "8f02227ee85ed96fd3499befc12cf00aad34dcdf436f0b58f29945432a69d4b4" => :yosemite
    sha256 "e32a8b4b74b3a41fb7ccf7933f0cc883c16d9fbd8ed55ff3d204556afa9d1a41" => :mavericks
  end

  devel do
    url "https://github.com/libevent/libevent/archive/release-2.1.6-beta.tar.gz"
    sha256 "388da3707a6060319fc8aff042e0abd8441f1134bf2a29318f040af68312ee3a"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/libevent/libevent.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-doxygen", "Don't build & install the manpages (uses Doxygen)"

  deprecated_option "enable-manpages" => "with-doxygen"

  depends_on "doxygen" => [:recommended, :build]
  depends_on "pkg-config" => :build
  depends_on "openssl"

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    ENV.universal_binary if build.universal?
    ENV.j1

    if build.with? "doxygen"
      inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    end

    system "./autogen.sh" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "doxygen"
      system "make", "doxygen"
      man3.install Dir["doxygen/man/man3/*.3"]
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-levent", "-o", "test"
    system "./test"
  end
end
