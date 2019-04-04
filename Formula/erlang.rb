class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.3.3.tar.gz"
  sha256 "c56d6c736163e93ee3edab0b3ae59209cfd751f0d8078a7ca83d63942202b706"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "2c4e861d2b80c4fbd4bec6d9b71c2d4ed06117303f832462b94f9b191cc68201" => :mojave
    sha256 "e198e71b219a66b8d5b4e2b4c28638cc11a5f59c8dab990a5e0af464f96b805c" => :high_sierra
    sha256 "224101bf8268f497f372b1198cdf296d2918c84e0fc14511f280daefbf7f183b" => :sierra
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
