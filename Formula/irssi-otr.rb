class IrssiOtr < Formula
  desc "LibOTR functionality in Irssi"
  homepage "https://github.com/cryptodotis/irssi-otr/"
  url "https://github.com/cryptodotis/irssi-otr/archive/v1.0.2.tar.gz"
  sha256 "4619208b9c9171aa97a41960b3e892390b6473e2988a056b9fe8e110daa1ae9c"

  depends_on "glib"
  depends_on "irssi"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # --with-irssi-headers doesn't really work
    inreplace "src/Makefile",
      "IRSSI_DIST = $(oldincludedir)/irssi",
      "IRSSI_DIST = #{Formula["irssi"].include/"irssi"}"
    # At the risk of doing https://www.xkcd.com/424/
    # When linking in OS X with clang "-Wl,-z,relro,-z,now" doesn't work but
    # "-z relro -z now" does. The latter is supposedly only to be used when
    # linking, but it does work when compiling too so ¯\_(ツ)_/¯
    # https://trac.torproject.org/projects/tor/ticket/21448#comment:14
    inreplace "src/Makefile",
      /^CFLAGS = (.*?) -Wl,-z,relro,-z,now (.*)$/,
      "CFLAGS = $1 -z relro -z now $2"
    system "make", "install"
  end

  def caveats; <<~EOS
    To load the plugin add:
      /load #{opt_prefix}/lib/irssi/modules/libotr
    to your ~/.irssi/startup
    EOS
  end

  test do
    system "true"
  end
end
