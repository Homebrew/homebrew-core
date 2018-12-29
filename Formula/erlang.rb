class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.2.2.tar.gz"
  sha256 "41b1c3a8343218157a683776e71d80a05ac4eb4019a90a760846608d78817690"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0406da7169491603755cb8274c138a78896a8c126f3c2d3607972fd067370b7f" => :mojave
    sha256 "8e61c5944f7965cf2d0b876203c7e13a94be5e2a88240852b549020baeee855b" => :high_sierra
    sha256 "eb6a663e911b7a29ea3273fa5ad258a5033e0caa23121139b98344deb24b7e37" => :sierra
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
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
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
