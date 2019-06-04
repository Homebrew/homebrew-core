class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.0.2.tar.gz"
  sha256 "7a9869f5da85349ef21bd9fbc8feafe1a1f563504a65924ddb542deeb37af7cd"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "f342938d37691065cfb6440f06875acada2ce869b1498f592dde47c7f7583c0f" => :mojave
    sha256 "cd1fd39430c2c79f2cb968de220eadbb18b90e8801109d2649e208bbd5719b6b" => :high_sierra
    sha256 "316d781057cb96b4c38d42d89f4b0d5bd085d98119320a64796616414dd4551b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.0.tar.gz"
    sha256 "c3acdb3c7c69eaceb8bcd5a69f8a19ba8320d403c176a3b560f9240b943ab370"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.0.tar.gz"
    sha256 "64da88a0045501264105b4cc8023821810d23058404a3aadb8da1bc8fb5c13cb"
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
