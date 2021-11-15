class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  license "LGPL-2.1"

  stable do
    url "https://mcabber.com/files/loudmouth/loudmouth-1.5.4.tar.bz2"
    sha256 "31cbc91c1fddcc5346b3373b8fb45594e9ea9cc7fe36d0595e8912c47ad94d0d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56ce5d15bd9625075e7160268936d0197a1116c1b3a095ebbbf190d2ac9becc7"
    sha256 cellar: :any,                 arm64_big_sur:  "0b60046b8a592ab656ed824b75774f2e9e8f9749b0a5edb024190019c36da766"
    sha256 cellar: :any,                 monterey:       "890ebdd35bf9275e771984de61b38557ff279e61d15e8c9d11813def0b65689a"
    sha256 cellar: :any,                 big_sur:        "d770f0cd1a81375c306d0bc6fdd81610d27bc844fd5086518aaa7f8fa6252a14"
    sha256 cellar: :any,                 catalina:       "b83be4ad6fce30f484015b344d21e3e425860b3c8a2cb6a609e059611d03caf9"
    sha256 cellar: :any,                 mojave:         "681944a95c5642a4651110e5d91d88acf335176b34d85f0f159aef291f07b38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6052693231034f7a87a85eb4e56755786089171b9ce5ad1e0babe0a891af55d9"
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libidn"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make"
    system "make", "check"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"examples/lm-send-async.c", testpath
    system ENV.cc, "lm-send-async.c", "-o", "test",
      "-L#{lib}", "-L#{Formula["glib"].opt_lib}", "-lloudmouth-1", "-lglib-2.0",
      "-I#{include}/loudmouth-1.0",
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test", "--help"
  end
end
