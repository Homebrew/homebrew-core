class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.3.tar.gz"
  sha256 "64a6eea6c1dc2353ad80e29ef57f6ec4192c91478ac2b854d0417b6b2bf4d9bf"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "43c90f9201147a819f25da9cf10be57ed5877d02c4e742b067ac12758daf2682" => :mojave
    sha256 "700d0c023d3159807659d42dcc2b2e3983bc6d453e02a5e459c762a733da7d62" => :high_sierra
    sha256 "995547cdd017bf50006936f760194ecf19726d40cd822143ec63b21581950e71" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_21.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_21.1.tar.gz"
    sha256 "021e47b5036eaa4671b6d87a910403b775c967bfcb79b56a87f2183ddc5a5df5"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_21.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_21.1.tar.gz"
    sha256 "85333f77ad12c2065be4dc40dc7057d1d192f7cf15c416513f0b595583f820ce"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
